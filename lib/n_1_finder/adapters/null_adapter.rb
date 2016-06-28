##
# Used when adapter not specified. Null object
#
class N1Finder::Adapters::NullAdapter < N1Finder::Adapters::BaseAdapter
  # Don't do anything
  #
  # @return [nil]
  def set_trap
  end

  # Don't do anything
  #
  # @return [nil]
  def remove_trap
  end
end
