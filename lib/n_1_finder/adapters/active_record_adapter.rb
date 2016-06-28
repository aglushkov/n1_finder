##
# Catches queries when using ActiveRecord
#
class N1Finder::Adapters::ActiveRecordAdapter < N1Finder::Adapters::BaseAdapter
  # Method in `database_class` that we observe to find N+1 queries
  #   Any activerecord connection adapter has a `exec_query` method
  #   http://api.rubyonrails.org/classes/ActiveRecord/Result.html
  MAIN_METHOD = :exec_query

  private

  def set_trap
    main_method = MAIN_METHOD
    main_method_alias = MAIN_METHOD_ALIAS
    current_storage = storage

    database_class.class_eval do
      alias_method main_method_alias, main_method
      define_method(main_method) do |*params, &block|
        sql = params.first
        sql_params = N1Finder::Adapters::ActiveRecordAdapter.find_sql_params(params)
        current_storage.add(sql, sql_params, caller)
        send(main_method_alias, *params, &block)
      end
    end
  end

  def database_class
    @database_class ||= ActiveRecord::Base.connection.class
  end

  class << self
    # Searches for activerecord sql params in array
    #
    # @param [Array] params
    #
    # @return [Hash] sql params
    def find_sql_params(params)
      binds = params.find do |param|
        param.is_a?(Array) && param.first.is_a?(Array) &&
          param.first.first.is_a?(ActiveRecord::ConnectionAdapters::Column)
      end || []

      Hash[binds].each_with_object({}) do |(key, value), object|
        object[key.name] = value
      end
    end
  end
end
