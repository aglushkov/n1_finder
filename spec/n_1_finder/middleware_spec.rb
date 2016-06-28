RSpec.describe N1Finder::Middleware do
  let(:app) { ->(env) { env } }
  let(:env) { 'OK' }
  let(:service) { described_class.new(app) }

  describe '#call' do
    subject { service.call(env) }

    it 'wraps app call into N1Finder.find method', type: :no_connection do
      expect(N1Finder).to receive(:find).and_call_original

      expect(subject).to eq 'OK'
    end
  end
end
