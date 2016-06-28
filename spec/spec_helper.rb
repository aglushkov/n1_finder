require 'pry-nav'
require 'bundler/setup'
Bundler.setup

require 'support/orm_helpers'
require 'active_record'
require 'sequel'
require 'support/n_1_helpers.rb'
require 'support/test_active_record_models'
require 'support/test_active_record_migration'
require 'support/test_sequel_models'
require 'support/test_sequel_migration'
require 'support/test_no_connection_models'
require 'n_1_finder'

include ORMHelpers

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.around(:each, type: :active_record_mysql) do |example|
    use_active_record(:mysql) { example.run }
  end

  config.around(:each, type: :active_record_pg) do |example|
    use_active_record(:pg) { example.run }
  end

  config.around(:each, type: :active_record_sqlite) do |example|
    use_active_record(:sqlite) { example.run }
  end

  config.around(:each, type: :sequel_mysql) do |example|
    use_sequel(:mysql) { example.run }
  end

  config.around(:each, type: :sequel_pg) do |example|
    use_sequel(:pg) { example.run }
  end

  config.around(:each, type: :sequel_sqlite) do |example|
    use_sequel(:sqlite) { example.run }
  end

  config.around(:each, type: :no_connection) do |example|
    use_no_connection { example.run }
  end

  config.order = :random
  Kernel.srand config.seed
end
