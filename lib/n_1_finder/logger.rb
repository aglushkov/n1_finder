require 'logger'

##
# Logs given N+1 queries
#
class N1Finder::Logger
  # Logs N+1 queries
  #
  # @param [Array[N1Finder::N1Query]] n1_queries
  #
  # @return [void]
  def log(n1_queries)
    n1_queries.each do |n1_query|
      logger.debug("\n" + message(n1_query) + "\n")
    end
  end

  private

  def logger
    @logger ||= N1Finder.logger
  end

  def message(n1_query)
    title = formatted('N+1 QUERY DETECTED:')
    query_title = formatted('QUERY:')
    line_title = formatted('LINE:')
    count_title = formatted('QUERIES COUNT:')
    queries_title = formatted('ORIGINAL QUERIES:')

    <<-MESSAGE.gsub(' ' * 6, '')
      #{title}
        #{query_title} #{n1_query.query}
        #{line_title} #{n1_query.line}
        #{count_title} #{n1_query.original_queries.count}
        #{queries_title}
          #{n1_query.original_queries.join("\n    ")}
    MESSAGE
  end

  def formatted(string)
    colorize? ? colored(string) : string
  end

  def colorize?
    log_filename = logger.instance_variable_get(:@logdev).filename
    log_filename.nil? || log_filename == 'STDOUT'
  end

  def colored(string)
    color = "\e[33m" # yellow
    reset = "\e[0m"

    "#{color}#{string}#{reset}"
  end
end
