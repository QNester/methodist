require_relative '../spec_helper'

RSpec.describe Methodist::Service do
  let!(:expected_client) { String.new }

  describe '#client' do
    it 'pass client to class method can be used in instance method' do
      described_class.client expected_client
      expect(described_class.new.client).to eq expected_client
    end
  end
end