# Combine ORM adapters
module N1Finder::Adapters
  # Adapters factory
  class Factory
    # Constructs new instance of adapter
    def self.get(key, storage)
      adapter_class = case key
        when :active_record then N1Finder::Adapters::ActiveRecordAdapter
        when :sequel then N1Finder::Adapters::SequelAdapter
        else N1Finder::Adapters::NullAdapter
      end

      adapter_class.new(storage)
    end
  end
end
