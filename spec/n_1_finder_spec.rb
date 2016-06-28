RSpec.describe N1Finder do
  describe 'self.find', type: :no_connection do
    let(:block) { -> { 'OK' } }
    let(:storage) { N1Finder::Storage.new }
    let(:logger) { instance_double(N1Finder::Logger, log: nil) }
    let(:n1_queries) { 'N1_QUERIES' }

    before do
      allow(N1Finder::Storage).to receive(:new).and_return(storage)
      allow(N1Finder::Logger).to receive(:new).and_return(logger)
      allow(N1Finder::N1Query).to \
        receive(:generate_by).with(storage.queries).and_return(n1_queries)
    end

    subject { described_class.find(&block) }

    it 'returns a block execution result' do
      expect(subject).to eq 'OK'
    end

    it 'finds queries in block' do
      expect(described_class).to receive(:catch_queries).with(storage)
      subject
    end

    it 'logs n+1 queries' do
      expect(logger).to receive(:log).with(n1_queries)
      subject
    end
  end

  describe '#logger=' do
    subject { described_class.logger = logger }
    context 'when logger is a Logger' do
      let(:logger) { Logger.new(STDOUT) }
      it 'sets a logger' do
        subject
        expect(described_class.logger).to eq logger
      end
    end

    context 'when logger is not a Logger' do
      let(:logger) { nil }
      it 'raises error' do
        expect { subject }.to raise_error described_class::InvalidLogger
      end
    end
  end

  describe '#orm=' do
    subject { described_class.orm = orm }
    context 'when provided supported orm' do
      let(:orm) { described_class::ORM_ADAPTERS.keys.sample }
      it 'sets orm' do
        subject
        expect(described_class.orm).to eq orm
      end
    end

    context 'when orm is not supported' do
      let(:orm) { :mongo }
      it 'raises error' do
        expect { subject }.to raise_error N1Finder::InvalidORM
      end
    end
  end
end
