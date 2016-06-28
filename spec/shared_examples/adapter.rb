RSpec.shared_examples 'adapter' do
  let(:service) { described_class.new(nil) }

  describe '#exec' do
    before do
      allow(service).to receive(:set_trap)
      allow(service).to receive(:remove_trap)
    end
    subject { service.exec(&block) }

    context 'when success executed block' do
      let(:block) { -> { 'OK' } }

      it 'returns passed block execution result' do
        expect(subject).to eq 'OK'
      end

      it 'clears after self' do
        expect(service).to receive(:remove_trap)
        subject
      end
    end

    context 'when block raises an error' do
      let(:block) { -> { raise 'error' } }

      it 'returns passed block execution result' do
        expect { subject }.to raise_error 'error'
      end

      it 'clears after self' do
        expect(service).to receive(:remove_trap)
        expect { subject }.to raise_error 'error'
      end
    end
  end
end
