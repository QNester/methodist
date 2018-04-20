require 'rails_helper'

RSpec.describe Hello::Genius do
  subject { described_class.new.call(input) }


  context 'valid input' do
    let!(:input) do

    end

    it 'returns success result' do
      expect(subject).to be_success
    end
  end

  context 'invalid input' do
    let!(:input) do

    end

    it 'returns success result' do
      expect(subject).to be_failure
    end
  end
end