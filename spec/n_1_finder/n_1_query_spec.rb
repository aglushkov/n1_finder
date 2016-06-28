RSpec.describe N1Finder::N1Query do
  describe 'self.generate_by' do
    let(:queries) do
      [
        N1Finder::Query.new('SELECT * FROM posts WHERE id = ?', { id: 1 }, ['line_1']),
        N1Finder::Query.new('SELECT * FROM users WHERE id = ?', { id: 1 }, ['line_2']),
        N1Finder::Query.new('SELECT * FROM users WHERE id = ?', { id: 1 }, ['line_1']),
        N1Finder::Query.new('SELECT * FROM posts WHERE id = ?', { id: 2 }, ['line_1'])
      ]
    end

    subject { described_class.generate_by(queries) }

    it 'returns n+1 queries' do
      expect(subject).to be_an Array
      expect(subject.count).to eq 1
      expect(subject.first).to be_an described_class
    end

    it 'sets attributes to n+1 queries' do
      n1_query = subject.first
      expect(n1_query.query).to eq 'SELECT * FROM posts WHERE id = ?, id = [id]'
      expect(n1_query.line).to eq 'line_1'
      expect(n1_query.original_queries[0]).to eq 'SELECT * FROM posts WHERE id = ?, id = 1'
      expect(n1_query.original_queries[1]).to eq 'SELECT * FROM posts WHERE id = ?, id = 2'
    end
  end
end
