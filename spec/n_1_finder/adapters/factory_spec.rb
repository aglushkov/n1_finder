RSpec.describe N1Finder::Adapters::Factory do
  describe '.get' do
    let(:storage) { 'STORAGE' }
    subject { described_class.get(key, storage) }

    context 'getting active_record' do
      let(:key) { :active_record }
      it 'should return active_record adapter' do
        expect(subject).to be_a(N1Finder::Adapters::ActiveRecordAdapter)
      end
      it 'should set storage' do
        expect(subject.storage).to eq storage
      end
    end

    context 'getting sequel' do
      let(:key) { :sequel }
      it 'should return sequel adapter' do
        expect(subject).to be_a(N1Finder::Adapters::SequelAdapter)
      end
      it 'should set storage' do
        expect(subject.storage).to eq storage
      end
    end

    context 'getting other adapter' do
      let(:key) { :other }
      it 'should return sequel adapter' do
        expect(subject).to be_a(N1Finder::Adapters::NullAdapter)
      end
      it 'should set storage' do
        expect(subject.storage).to eq storage
      end
    end
  end
end
