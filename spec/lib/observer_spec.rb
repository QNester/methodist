require_relative '../spec_helper'

RSpec.describe Methodist::Observer do
  describe '#observe' do
    let!(:expected_text) { FFaker::Lorem.phrase }
    let!(:observed_klass) { String }

    context 'observe instance method' do
      let!(:observed_method) { :to_i }

      after(:each) do
        described_class.stop_observe(observed_klass, observed_method)
      end

      context 'pass execution block in observe' do
        subject do
          Methodist::Observer.observe(observed_klass, observed_method) do
            puts expected_text
          end
        end

        it 'add method to observed_methods' do
          subject
          expect(described_class.observed_methods).to include("#{observed_klass}##{observed_method}")
        end

        it 'execute passed block after call observed method' do
          subject
          expect(STDOUT).to receive(:puts).with(expected_text)
          observed_klass.new(rand.to_s).to_i
        end
      end

      context 'pass execution block in #execute' do

        subject { Methodist::Observer.observe String, :to_i }

        before do
          Methodist::Observer.execute do
            puts expected_text
          end
        end

        it 'add method to observed_methods' do
          subject
          expect(described_class.observed_methods).to include("#{observed_klass}##{observed_method}")
        end

        it 'execute passed block after call observed method' do
          subject
          expect(STDOUT).to receive(:puts).with(expected_text)
          rand.to_s.to_i
        end
      end
    end

    context 'observe class method' do
      let!(:observed_method) { :new }

      after(:each) do
        described_class.stop_observe(observed_klass, observed_method, instance_method: false)
      end

      context 'pass execution block in observe' do
        subject do
          Methodist::Observer.observe(observed_klass, observed_method, instance_method: false) do
            puts expected_text
          end
        end

        it 'add method to observed_methods' do
          subject
          expect(described_class.observed_methods).to include("<ClassMethod:#{observed_klass}##{observed_method}")
        end

        it 'execute passed block after call observed method' do
          subject
          expect(STDOUT).to receive(:puts).with(expected_text)
          observed_klass.send(observed_method)
        end
      end

      context 'pass execution block in #execute' do

        subject { Methodist::Observer.observe String, observed_method, instance_method: false }

        before do
          Methodist::Observer.execute do
            puts expected_text
          end
        end

        it 'add method to observed_methods' do
          subject
          expect(described_class.observed_methods).to include("<ClassMethod:#{observed_klass}##{observed_method}")
        end

        it 'execute passed block after call observed method' do
          subject
          expect(STDOUT).to receive(:puts).with(expected_text)
          observed_klass.send(observed_method)
        end
      end
    end
  end

  describe '#observe_class_method' do
    it 'call #observe method with `instance_method: false`' do
      expect(described_class).to receive(:observe).with(String, :new, any_args)
      described_class.observe_class_method(String, :new)
    end
  end

  describe '#stop_observe' do
    let(:expected_text) { FFaker::Lorem.phrase }

    before do
      Methodist::Observer.observe String, :to_i
      Methodist::Observer.observe InstaPostBuilder, :attributes, instance_method: false
      Methodist::Observer.execute do
        puts expected_text
      end
    end

    after do
      Methodist::Observer.stop_observe String, :to_i
      Methodist::Observer.stop_observe InstaPostBuilder, :attributes, instance_method: false
    end

    context 'instance method observed' do
      subject { Methodist::Observer.stop_observe String, :to_i }

      it 'remove method from observer_methods' do
        expect(described_class.observed_methods).to include("String#to_i")
        subject
        expect(described_class.observed_methods).not_to include("String#to_i")
      end

      it 'NOT execute passed block after call observed method' do
        subject
        expect(STDOUT).not_to receive(:puts).with(expected_text)
        rand.to_s.to_i
      end
    end

    context 'class method observed' do
      subject { Methodist::Observer.stop_observe InstaPostBuilder, :attributes, instance_method: false}

      it 'remove method from observer_methods' do
        expect(described_class.observed_methods).to include("<ClassMethod:InstaPostBuilder#attributes")
        subject
        expect(described_class.observed_methods).not_to include("<ClassMethod:InstaPostBuilder#attributes")
      end

      it 'NOT execute passed block after call observed method' do
        subject
        expect(STDOUT).not_to receive(:puts).with(expected_text)
        InstaPostBuilder.attributes
      end
    end
  end
end