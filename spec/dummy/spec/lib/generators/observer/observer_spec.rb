require 'rails_helper'

MODULE_NAME = %w[anything modulname in my life i dont wanna die and doesnt help me nothing].sample
KLASS_NAME = %w[jhonny field summa kiddo verify kilo pender finder guava].sample

RSpec.describe ObserverGenerator, type: :generator do
  destination File.expand_path(TMP_PATH, __FILE__)

  before(:each) do
    prepare_destination
  end

  after(:each) do
    FileUtils.rm_rf(TMP_PATH)
  end

  context 'without options' do
    subject { run_generator(["#{MODULE_NAME}/#{KLASS_NAME}"]) }

    let!(:expected_file)      { "#{TMP_PATH}/config/initializers/observers/#{MODULE_NAME}/#{KLASS_NAME}_observer.rb" }

    it 'creates observer file' do
      subject
      expect(File).to exist(expected_file)
    end
  end

  context 'with option --path' do
    CUSTOM_PATH = 'lib/testing'

    subject { run_generator(["#{MODULE_NAME}/#{KLASS_NAME}", "--path=#{CUSTOM_PATH}"]) }

    let!(:expected_file)      { "#{TMP_PATH}/config/initializers/#{CUSTOM_PATH}/#{MODULE_NAME}/#{KLASS_NAME}_observer.rb" }

    it 'creates observer file in path' do
      subject
      expect(File).to exist(expected_file)
    end
  end

  context 'with option --in-lib' do
    subject { run_generator(["#{MODULE_NAME}/#{KLASS_NAME}", "--in-lib"]) }

    let!(:expected_file)      { "#{TMP_PATH}/lib/observers/#{MODULE_NAME}/#{KLASS_NAME}_observer.rb" }

    it 'creates observer file in path' do
      subject
      expect(File).to exist(expected_file)
    end
  end
end