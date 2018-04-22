require_relative '../spec_helper'
require_relative '../testing_classes/interactor/test_interactor'
require_relative '../testing_classes/interactor/test_interactor_no_schema'

RSpec.describe Methodist::Interactor do
  it 'has instance method `validate`' do
    expect(Methodist::Interactor.instance_methods(false).include?(:validate))
  end

  it 'has class method `schema`' do
    expect(Methodist::Interactor.singleton_methods(false).include?(:schema))
  end

  describe TestInteractor do
    subject { described_class.new.call(input) }

    context 'valid input' do
      let(:input) { { name: FFaker::Name.name } }

      it { expect(subject).to be_success }
    end

    context 'invalid input' do
      let(:input) { { name: nil }}

      it { expect(subject).to be_failure }

      it 'correct result value' do
        expect(subject.value[:error]).to eq('ValidationError')
        expect(subject.value[:field].to_sym).to eq(:name)
      end
    end
  end

  describe TestInteractorNoSchema do
    subject { described_class.new.call(name: FFaker::Name.name) }

    it { expect { subject }.to raise_error(Methodist::Interactor::SchemaDefinitionError) }
  end
end
