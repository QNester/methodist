require_relative '../spec_helper'
require_relative '../testing_classes/builder/test_builder'
require_relative '../testing_classes/builder/test_validations_builder'

RSpec.describe Methodist::Builder do
  describe 'class methods' do
    it 'has instance method #valid?' do
      Methodist::Builder.instance_methods.include?(:valid?)
    end

    describe '#attr_accessor' do
      subject { described_class.attr_accessor :test_field }

      it 'add attrs to attributes' do
        subject
        expect(described_class.attributes).to eq([:test_field])
        expect(described_class.attrs).to eq([:test_field])
      end
    end

    describe '#field' do
      subject { described_class.field :test_field, -> (value) { value.is_a?(String) } }

      it 'add attrs to attributes array' do
        subject
        expect(described_class.attributes).to eq([:test_field])
      end

      it 'add proc to validation proc constant' do
        subject
        expect(described_class.const_get('VALIDATION_PROC_TEST_FIELD')).to be_truthy
        expect(described_class.const_get('VALIDATION_PROC_TEST_FIELD')).to be_instance_of(Proc)
      end
    end
  end

  describe TestBuilder do
    describe '#to_h' do
      let!(:title) { FFaker::Book.title }
      let!(:author) { FFaker::Book.author }

      subject do
        builder = TestBuilder.new
        builder.title = title
        builder.author = author
        builder
      end

      it 'returns attributes as hash' do
        expect(subject.to_h).to eq(title: title, author: author)
      end

      context 'one attribute nil' do
        subject do
          builder = TestBuilder.new
          builder.title = title
          builder.author = nil
          builder
        end

        it 'returns attributes as hash' do
          expect(subject.to_h).to eq(title: title, author: nil)
        end
      end
    end
  end

  describe TestValidationsBuilder do
    describe '#valid?' do
      it 'returns true if proc returns truthy' do
        subject
        klass_instance = described_class.new
        klass_instance.title = FFaker::Lorem.phrase
        expect(klass_instance.valid?).to eq(true)
      end

      it 'return false if proc returns falsey' do
        subject
        klass_instance = described_class.new
        klass_instance.title = nil
        expect(klass_instance.valid?).to eq(false)
      end
    end
  end
end