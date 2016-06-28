RSpec.describe N1Finder::Logger do
  let(:service) { described_class.new }
  let(:n1_queries) do
    [
      instance_double(
        N1Finder::N1Query,
        line: 'line',
        query: 'query',
        original_queries: %w(one two)
      )
    ]
  end

  let(:logger) { Logger.new(STDOUT) }
  before { allow(service).to receive(:logger).and_return logger }

  describe '#log' do
    subject { service.log(n1_queries) }

    it 'logs line' do
      expect(logger).to receive(:debug).once.with(include('line'))
      subject
    end

    it 'logs query footprint' do
      expect(logger).to receive(:debug).once.with(include('query'))
      subject
    end

    it 'logs original_queries' do
      expect(logger).to receive(:debug).once.with(include('one') && include('two'))
      subject
    end

    it 'logs similar queries count' do
      expect(logger).to receive(:debug).once.with(include(2.to_s))
      subject
    end
  end
end
