require 'securerandom'

RSpec.describe N1Finder::Query do
  let(:service) { described_class.new(query, params, backtrace) }
  let(:query) { nil }
  let(:params) { {} }
  let(:backtrace) { nil }
  let(:id) { rand(1..100_000) }
  let(:uuid) { SecureRandom.uuid }

  describe '#query_footprint' do
    subject { service.send(:query_footprint) }

    context 'with id' do
      let(:query) { "id = #{id}" }
      it 'replaces id to mask' do
        expect(subject).to eq 'id = [id]'
      end
    end

    context 'with uuid' do
      let(:query) { "id = '#{SecureRandom.uuid}'" }
      it 'replaces id to mask' do
        expect(subject).to eq 'id = [uuid]'
      end
    end

    context 'without id or uuid' do
      let(:query) { 'SELECT * FROM posts' }
      it 'returns query without changes' do
        expect(subject).to eq query
      end
    end

    context 'with both id and uuid' do
      let(:query) { "id = '#{SecureRandom.uuid}' AND author_id = #{id}" }
      it 'replaces uuid and id to mask' do
        expect(subject).to eq 'id = [uuid] AND author_id = [id]'
      end
    end

    context 'with number in param' do
      let(:query) { "id1 = #{id}" }
      it 'not changes param name' do
        expect(subject).to eq 'id1 = [id]'
      end
    end
  end

  describe '#application_line' do
    subject { service.send(:application_line) }
    let(:backtrace) do
      [
        '../gems/..',
        '../app/file1.rb/..',
        '../app/file2.rb/..',
        '../gems/..'
      ]
    end
    it 'finds latest app backtrace line' do
      expect(subject).to eq '../app/file1.rb/..'
    end
  end

  describe '#footprint' do
    subject { service.footprint }
    let(:query) { "SELECT * FROM posts WHERE id = #{id}" }
    let(:backtrace) do
      [
        '../gems/..',
        '../app/file1.rb/..',
        '../app/file2.rb/..',
        '../gems/..'
      ]
    end
    it 'returns array of query footprint and application line' do
      expect(subject[:query]).to eq 'SELECT * FROM posts WHERE id = [id]'
      expect(subject[:line]).to eq '../app/file1.rb/..'
    end
  end
end
