RSpec.describe N1Finder do
  describe 'Using sequel and sqlite', type: :sequel_sqlite do
    before { populate_database }

    subject { described_class.find(&n_1_heavy_block) }

    it 'logs all N+1 queries' do
      expect(described_class.logger).to receive(:debug).exactly(3).times
      subject
    end
  end
end
