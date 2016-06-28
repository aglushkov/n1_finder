##
# Query representation
#
class N1Finder::Query
  # Regular expression to find numeric ids in queries and in params
  ID = /(?<==\s)\d+/

  # Regular expression to find UUIDs in queries and in params
  UUID = /(?<==\s)(['"])\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\1/

  # @!attribute [r] query
  #   Original query string combined with params
  # @!attribute [backtrace] line
  #   Backtrace up to function where we cought this query
  attr_reader :query, :backtrace

  # @param [String] query
  # @param [Hash] params
  # @param [Array<String>] backtrace
  def initialize(query, params, backtrace)
    @query = self.class.query_with_params(query, params)
    @backtrace = backtrace
  end

  # Generates query footprint
  # Footprint consists of
  #   - query with masked ids
  #   - line of code where this query was executed
  #
  # @return [ {query, line} => String ]
  def footprint
    @footprint ||= { query: query_footprint, line: application_line }
  end

  # Combines query and its params to readable format
  #
  # @param [String] query
  # @param [Hash] params
  #
  # @return [String]
  def self.query_with_params(query, params)
    params.map do |key, value|
      value = "'#{value}'" if value.is_a?(String)
      "#{key} = #{value}"
    end.unshift(query).join(', ')
  end

  private

  def query_footprint
    @query_footprint ||= query.gsub(UUID, '[uuid]').gsub(ID, '[id]')
  end

  def application_line
    @application_line ||= backtrace.find { |line| !line.include?('/gems/') }
  end
end
