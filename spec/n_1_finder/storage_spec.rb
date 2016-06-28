RSpec.describe N1Finder::Storage do
  let(:service) { described_class.new }

  describe '#queries' do
    subject { service.queries }

    it 'returns an Array' do
      expect(subject).to be_an Array
    end
  end

  describe '#add' do
    subject { service.add(query, params, backtrace) }

    let(:query) { 'query' }
    let(:params) { {} }
    let(:backtrace) { [] }

    it 'adds query to queries collection' do
      expect { subject }.to change { service.queries.count }.by 1
    end
  end
end
