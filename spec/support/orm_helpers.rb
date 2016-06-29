# rubocop:disable Metrics/LineLength

module ORMHelpers
  DB_PARAMS = Hash.new { |hash, _key| hash['mri'] }.update(
    'mri' => {
      active_record: {
        sqlite: 'sqlite3::memory:',
        pg: "postgres://#{ENV['PG_USERNAME']}:#{ENV['PG_PASSWORD']}@localhost/#{ENV['PG_DATABASE']}",
        mysql: "mysql://#{ENV['MYSQL_USERNAME']}:#{ENV['MYSQL_PASSWORD']}@localhost/#{ENV['MYSQL_DATABASE']}"
      },
      sequel: {
        sqlite: 'sqlite::memory:',
        pg: "postgres://#{ENV['PG_USERNAME']}:#{ENV['PG_PASSWORD']}@localhost/#{ENV['PG_DATABASE']}",
        mysql: "mysql://#{ENV['MYSQL_USERNAME']}:#{ENV['MYSQL_PASSWORD']}@localhost/#{ENV['MYSQL_DATABASE']}"
      }
    },
    'java' => {
      active_record: {
        sqlite: 'sqlite3::memory:',
        pg: "postgresql://#{ENV['PG_USERNAME']}:#{ENV['PG_PASSWORD']}@localhost/#{ENV['PG_DATABASE']}",
        mysql: "mysql://#{ENV['MYSQL_USERNAME']}:#{ENV['MYSQL_PASSWORD']}@localhost/#{ENV['MYSQL_DATABASE']}"
      },
      sequel: {
        sqlite: 'jdbc:sqlite::memory:',
        pg: "jdbc:postgresql://localhost/#{ENV['PG_DATABASE']}?user=#{ENV['PG_USERNAME']}&password=#{ENV['PG_PASSWORD']}",
        mysql: "jdbc:mysql://localhost/#{ENV['MYSQL_DATABASE']}?user=#{ENV['MYSQL_USERNAME']}&password=#{ENV['MYSQL_PASSWORD']}"
      }
    }
  )

  def connect_sequel(adapter)
    Sequel::Model.db = Sequel.connect(DB_PARAMS[RUBY_PLATFORM][:sequel][adapter])
    TestSequelMigration.up
  end

  def connect_active_record(adapter)
    ActiveRecord::Base.establish_connection(DB_PARAMS[RUBY_PLATFORM][:active_record][adapter])
    silence_stream(STDOUT) { TestActiveRecordMigration.up }
  end

  def use_active_record(adapter)
    N1Finder.orm = :active_record
    connect_active_record(adapter)

    extend TestActiveRecordModels
    extend N1Helpers

    ActiveRecord::Base.transaction do
      yield
      raise ActiveRecord::Rollback
    end
  end

  def use_sequel(adapter)
    N1Finder.orm = :sequel
    connect_sequel(adapter)

    extend TestSequelModels
    extend N1Helpers

    Sequel::Model.db.transaction(rollback: :always) do
      yield
    end
  end

  def use_no_connection
    N1Finder.instance_variable_set(:@orm, :no_connection)
    extend TestNoConnectionModels
    yield
  end
end
