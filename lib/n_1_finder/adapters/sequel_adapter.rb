##
# Catches queries when using Sequel
#
class N1Finder::Adapters::SequelAdapter < N1Finder::Adapters::BaseAdapter
  # Method in `Sequel::Model.db.class` that we observe to find N+1 queries
  #   Each sequel adapter has `execute` method
  #   For example:
  #   https://github.com/jeremyevans/sequel/blob/ac925ce9556f33d56f49b84d905d307c6a621716/lib/sequel/adapters/postgres.rb#L171
  #   https://github.com/jeremyevans/sequel/blob/ac925ce9556f33d56f49b84d905d307c6a621716/lib/sequel/adapters/mysql.rb#L352
  #   https://github.com/jeremyevans/sequel/blob/ac925ce9556f33d56f49b84d905d307c6a621716/lib/sequel/adapters/sqlite.rb#L129
  MAIN_METHOD = :execute

  private

  def set_trap
    main_query_method = MAIN_METHOD
    main_method_alias = MAIN_METHOD_ALIAS
    current_storage = storage

    database_class.class_eval do
      alias_method main_method_alias, main_query_method
      define_method(main_query_method) do |*params, &block|
        sql = params.first
        current_storage.add(sql, {}, caller)
        send(main_method_alias, *params, &block)
      end
    end
  end

  def database_class
    @database_class ||= Sequel::Model.db.class
  end
end
