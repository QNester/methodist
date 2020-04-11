require_relative '../spec_helper'
require_relative '../testing_classes/builder/test_builder'
require_relative '../testing_classes/builder/test_validations_builder'

RSpec.describe Methodist::Builder do
  describe 'class methods' do
    it 'has instance method #valid?' do
      Methodist::Builder.instance_methods.include?(:valid?)
      Methodist::Builder.instance_methods.include?(:valid_attr?)
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
      let!(:instance) { described_class.new }
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

      context 'with prepare' do
        let!(:set_value) { 'TEST_VALUE'.upcase }
        subject do
          described_class.field :test_field,
            -> (value) { value.is_a?(String) },
            prepare: ->(val) { val.downcase }
        end

        it 'apply prepare block for value' do
          subject
          instance.test_field = set_value
          expect(instance.test_field).to eq(set_value.downcase)
        end
      end

      context 'with default' do
        let!(:default_value) { 'DEFAULT_VAL' }
        subject { described_class.field :test_field, -> (value) { value.is_a?(String) }, default: default_value }

        context 'field was set' do
          context 'value is valid' do
            before { instance.test_field = set_value }
            let!(:set_value) { 'SET_VAL' }

            it 'returns set value' do
              subject
              expect(instance.public_send(:test_field)).to eq(set_value)
            end
          end

          context 'value is invalid' do
            let!(:set_value) { {} }
            context 'without raise_invalid' do
              it 'returns default value' do
                subject
                instance.test_field = set_value
                expect(instance.public_send(:test_field)).to eq(default_value)
              end
            end

            context 'pass raise_invalid true' do
              subject do
                described_class.field(:test_field,
                  ->(value) { value.is_a?(String) },
                  default: default_value,
                  raise_invalid: true
                )
              end

              it 'raise InvalidValueError in setting field' do
                subject
                expect { instance.test_field = set_value }.to raise_error(described_class::InvalidValueError)
              end
            end
          end
        end

        context 'field was not set' do
          it 'returns default value' do
            subject
            expect(instance.public_send(:test_field)).to eq(default_value)
          end
        end
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