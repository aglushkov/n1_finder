require 'shared_examples/adapter'

RSpec.describe N1Finder::Adapters::NullAdapter do
  it_behaves_like 'adapter'
end
