RSpec.shared_examples :create_files do |pattern, options = {}|
  destination File.expand_path(TMP_PATH, __FILE__)

  let!(:filename) do
    return "#{KLASS_NAME}.rb" if options[:no_pattern_in_file_name]
    "#{KLASS_NAME}_#{pattern}.rb"
  end

  let!(:filename_spec) do
    return "#{KLASS_NAME}_spec.rb" if options[:no_pattern_in_file_name]
    "#{KLASS_NAME}_#{pattern}_spec.rb"
  end

  before(:each) do
    prepare_destination
  end

  after(:each) do
    FileUtils.rm_rf(TMP_PATH)
  end

  context 'without options' do
    subject { run_generator(["#{MODULE_NAME}/#{KLASS_NAME}"]) }

    let!(:expected_file)      { "#{TMP_PATH}/app/#{pattern}s/#{MODULE_NAME}/#{filename}" }
    let!(:expected_spec_file) { "#{TMP_PATH}/spec/#{pattern}s/#{MODULE_NAME}/#{filename_spec}" }

    it 'creates interactor file' do
      subject
      expect(File).to exist(expected_file)
    end

    it 'creates spec file' do
      subject
      expect(File).to exist(expected_spec_file)
    end

    context 'rspec not defined' do
      before do
        allow_any_instance_of(described_class).to receive(:rspec_used?).and_return(false)
      end

      it 'creates interactor file' do
        subject
        expect(File).to exist(expected_file)
      end

      it 'not creates spec file' do
        subject
        expect(File).not_to exist(expected_spec_file)
      end
    end
  end

  context 'with option --path' do
    CUSTOM_PATH = 'lib/testing'

    subject { run_generator(["#{MODULE_NAME}/#{KLASS_NAME}", "--path=#{CUSTOM_PATH}"]) }

    let!(:expected_file)      { "#{TMP_PATH}/app/#{CUSTOM_PATH}/#{MODULE_NAME}/#{filename}" }
    let!(:expected_spec_file) { "#{TMP_PATH}/spec/#{CUSTOM_PATH}/#{MODULE_NAME}/#{filename_spec}" }

    it 'creates interactor file in path' do
      subject
      expect(File).to exist(expected_file)
    end

    it 'creates spec file in path' do
      subject
      expect(File).to exist(expected_spec_file)
    end
  end

  context 'with option --in-lib' do
    subject { run_generator(["#{MODULE_NAME}/#{KLASS_NAME}", "--in-lib"]) }

    let!(:expected_file)      { "#{TMP_PATH}/lib/#{pattern}s/#{MODULE_NAME}/#{filename}" }
    let!(:expected_spec_file) { "#{TMP_PATH}/spec/lib/#{pattern}s/#{MODULE_NAME}/#{filename_spec}" }

    it 'creates interactor file in path' do
      subject
      expect(File).to exist(expected_file)
    end

    it 'creates spec file in path' do
      subject
      expect(File).to exist(expected_spec_file)
    end
  end
end