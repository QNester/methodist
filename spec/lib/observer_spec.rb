require_relative '../spec_helper'

RSpec.describe Methodist::Observer do
  describe '#observe' do
    let(:expected_text) { FFaker::Lorem.phrase }

    subject { Methodist::Observer.observe String, :to_i}

    before do
      Methodist::Observer.execute do
        puts expected_text
      end
    end

    it 'add method to observed_methods' do
      subject
      expect(described_class.observed_methods).to include('String#to_i')
    end

    it 'execute passed block after call observed method' do
      subject
      expect(STDOUT).to receive(:puts).with(expected_text)
      rand.to_s.to_i
    end
  end

  describe '#stop_observe' do
    let(:expected_text) { FFaker::Lorem.phrase }

    before do
      Methodist::Observer.observe String, :to_i
      Methodist::Observer.execute do
        puts expected_text
      end
    end

    subject { Methodist::Observer.stop_observe String, :to_i}

    it 'remove method from observer_methods' do
      expect(described_class.observed_methods).to include('String#to_i')
      subject
      expect(described_class.observed_methods).not_to include('String#to_i')
    end

    it 'NOT execute passed block after call observed method' do
      subject
      expect(STDOUT).not_to receive(:puts).with(expected_text)
      rand.to_s.to_i
    end
  end
end