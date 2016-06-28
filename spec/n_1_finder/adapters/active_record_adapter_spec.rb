require 'shared_examples/adapter'

RSpec.describe N1Finder::Adapters::ActiveRecordAdapter do
  it_behaves_like 'adapter'

  describe '#find_sql_params' do
    subject { described_class.find_sql_params(params) }

    context 'with empty params' do
      let(:params) { [] }
      it 'returns empty hash' do
        expect(subject).to eq({})
      end
    end

    context 'without sql params' do
      let(:params) { ['some sql', { some: 'hash' }, [%w(some array)]] }
      it 'returns empty hash' do
        expect(subject).to eq({})
      end
    end

    context 'without sql params' do
      let(:params) do
        [
          [
            [ActiveRecord::ConnectionAdapters::Column.new(:first_name, nil, nil), 'jane'],
            [ActiveRecord::ConnectionAdapters::Column.new(:last_name, nil, nil), 'doe']
          ]
        ]
      end
      it 'returns empty hash' do
        expect(subject).to eq(first_name: 'jane', last_name: 'doe')
      end
    end
  end
end
