# Main class
class N1Finder
  # Supported ORM adapters
  ORM_ADAPTERS = [:active_record, :sequel].freeze

  class << self
    # Supported ORM adapters

    # Searches for N+1 queries and logs results
    #
    # @yield block
    #
    # @return [void] result of block call
    def find
      storage = N1Finder::Storage.new
      result = catch_queries(storage) { yield }
      n1_queries = N1Finder::N1Query.generate_by(storage.queries)
      N1Finder::Logger.new.log(n1_queries)

      result
    end

    # Logger to log N+1 queries
    #
    # Defaults to `Logger.new(STDOUT)`
    #
    # @return [Logger]
    def logger
      @logger ||= ::Logger.new(STDOUT)
    end

    # Configure logger
    #
    # @param [Logger] custom_logger
    #   Must be instance of `Logger`
    #
    # @raise [N1Finder::Errors::InvalidLogger] If custom_logger is not an instance of `Logger`.
    #
    # @return [Logger]
    def logger=(custom_logger)
      raise Errors::InvalidLogger unless custom_logger.is_a?(::Logger)

      @logger = custom_logger
    end

    # ORM used in project
    #  Default to :active_record if ActiveRecord defined
    #  Default to :sequel if Sequel defined
    #  Default to nil if ActiveRecord and Sequel are not defined
    #
    # @return [Symbol, nil]
    def orm
      @orm ||=
        if defined?(ActiveRecord)
          :active_record
        elsif defined?(Sequel)
          :sequel
        end
    end

    # Configure ORM
    #
    # @param [Symbol] custom_orm
    #   Must be `:active_record` or `:sequel`
    #
    # @raise [N1Finder::Errors::InvalidORM] If custom_orm is not in allowed list.
    #
    # @return [Symbol]
    def orm=(custom_orm)
      raise Errors::InvalidORM unless ORM_ADAPTERS.include?(custom_orm)

      @orm = custom_orm
    end

    private

    def catch_queries(storage)
      adapter = Adapters::Factory.get(orm, storage)
      adapter.exec(&Proc.new)
    end
  end
end

require 'n_1_finder/logger'
require 'n_1_finder/middleware'
require 'n_1_finder/query'
require 'n_1_finder/n_1_query'
require 'n_1_finder/storage'
require 'n_1_finder/adapters/factory'
require 'n_1_finder/adapters/base_adapter'
require 'n_1_finder/adapters/active_record_adapter'
require 'n_1_finder/adapters/sequel_adapter'
require 'n_1_finder/adapters/null_adapter'
require 'n_1_finder/errors/base'
require 'n_1_finder/errors/invalid_orm'
require 'n_1_finder/errors/invalid_logger'
