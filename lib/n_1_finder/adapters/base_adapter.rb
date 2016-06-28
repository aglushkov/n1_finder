##
# Combine ORM adapters
#
module N1Finder::Adapters
  # Adds common functionality to other adapters
  class BaseAdapter
    # An alias that we create for MAIN_METHOD function
    MAIN_METHOD_ALIAS = :main_method_alias

    # @!attribute [r] storage
    #   Storage that stores queries
    attr_reader :storage

    def initialize(storage)
      @storage = storage
    end

    # Replaces original query execution function (defined in MAIN_METHOD)
    # with our function that collects all queries and calls original function.
    # After passed block yileds, replaces our function with origianal and
    # removes our function.
    #
    # @yield passed block
    #
    # @return passed block execution result
    def exec
      set_trap
      yield
    ensure
      remove_trap
    end

    private

    def remove_trap
      main_query_method = self.class::MAIN_METHOD
      main_method_alias = MAIN_METHOD_ALIAS

      database_class.class_eval do
        remove_method(main_query_method)
        alias_method main_query_method, main_method_alias
        remove_method(main_method_alias)
      end
    end
  end
end
