require 'rails_helper'

RSpec.describe Hello::World do
  subject { described_class.new.call(input) }


  context 'valid input' do
    let!(:input) do

      # valid input for your interactor

    end

    it 'returns success result' do
      expect(subject).to be_success
    end
  end

  context 'invalid input' do
    let!(:input) do

      # failure input for yout interactor

    end

    it 'returns success result' do
      expect(subject).to be_failure
    end
  end
end