require 'spec_helper'

RSpec.describe Methodist do
  it { expect(Methodist).to be_instance_of(Module) }
  it { expect(Methodist::Interactor).to be_instance_of(Class) }
  it { expect(Methodist::Observer).to be_instance_of(Class) }
end