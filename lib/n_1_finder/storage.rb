##
# Storage for queries
#
class N1Finder::Storage
  # Stored queries. Default is `[]`.
  #
  # @return [Array[N1Finder::Query]]
  attr_reader :queries

  def initialize
    @queries = []
  end

  # Adds query to storage
  #
  # @param [String] query the sql query
  # @param [Array[String]] backtrace the backtrace up to query execution
  #
  # @return [void]
  def add(query, params, backtrace)
    queries << N1Finder::Query.new(query, params, backtrace)
  end
end
