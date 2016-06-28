##
# N+1 queries representation
#
class N1Finder::N1Query
  # @!attribute [r] query
  #   Query with masked ids
  # @!attribute [r] line
  #   Line where queries were executed in application
  # @!attribute [r] original_queries
  #   All similar (N+1) original queries strings
  attr_reader :query, :line, :original_queries

  # A new instance of N1Finder::N1Query query initialized by similar queries
  #
  # @param [Array<N1Finder::Query>] queries
  def initialize(queries)
    @query = queries.first.footprint[:query]
    @line = queries.first.footprint[:line]
    @original_queries = queries.map(&:query)
  end

  # Generates N1Finder::N1Query from array of N1Finder::Query
  #
  # @param [Array<N1Finder::Query>] queries
  #
  # @return [Array<N1Finder::N1Query>] queries that have N+1 vulnerability
  def self.generate_by(queries)
    grouped_queries = queries.group_by(&:footprint)

    n1_grouped_queries = grouped_queries.select do |_, similar_queries|
      similar_queries.count > 1
    end

    n1_grouped_queries.map do |_, similar_queries|
      new(similar_queries)
    end
  end
end
