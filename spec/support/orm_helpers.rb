module ORMHelpers
  DB_PARAMS = {
    active_record: {
      sqlite: {
        adapter: 'sqlite3',
        database: ':memory:'
      },
      pg: {
        adapter: 'postgresql',
        host: 'localhost',
        username: ENV['PG_USERNAME'].to_s,
        password: ENV['PG_PASSWORD'].to_s,
        database: ENV['PG_DATABASE'].to_s
      },
      mysql: {
        adapter: 'mysql',
        host: 'localhost',
        username: ENV['MYSQL_USERNAME'].to_s,
        password: ENV['MYSQL_PASSWORD'].to_s,
        database: ENV['MYSQL_DATABASE'].to_s
      }
    },
    sequel: {
      sqlite: {
        adapter: 'sqlite',
        database: ':memory:'
      },
      pg: {
        adapter: 'postgres',
        host: 'localhost',
        username: ENV['PG_USERNAME'].to_s,
        password: ENV['PG_PASSWORD'].to_s,
        database: ENV['PG_DATABASE'].to_s
      },
      mysql: {
        adapter: 'mysql',
        host: 'localhost',
        username: ENV['MYSQL_USERNAME'].to_s,
        password: ENV['MYSQL_PASSWORD'].to_s,
        database: ENV['MYSQL_DATABASE'].to_s
      }
    }
  }.freeze

  def connect_sequel(adapter)
    Sequel::Model.db = Sequel.connect(DB_PARAMS[:sequel][adapter])
    TestSequelMigration.up
  end

  def connect_active_record(adapter)
    ActiveRecord::Base.establish_connection(DB_PARAMS[:active_record][adapter])
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
