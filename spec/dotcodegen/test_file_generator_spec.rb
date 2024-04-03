# frozen_string_literal: true

require 'dotcodegen/test_file_generator'

RSpec.describe Dotcodegen::TestFileGenerator do
  let(:file_path) { 'client/app/components/feature.tsx' }
  let(:api_matcher) do
    {
      'regex' => 'api/.*\.rb',
      'root_path' => 'api/app/',
      'test_root_path' => 'api/spec/',
      'test_file_suffix' => '_spec.rb'
    }
  end
  let(:client_matcher) do
    {
      'regex' => 'client/app/.*\.tsx',
      'test_file_suffix' => '.test.tsx'
    }
  end
  let(:matchers) { [api_matcher, client_matcher] }
  let(:openai_key) { 'test_openai_key' }
  let(:codegen_instance) { instance_double(Dotcodegen::TestFileGenerator) }

  subject { described_class.new(file_path:, matchers:, openai_key:) }

  describe '#run' do
    after(:each) { FileUtils.remove_dir('client/', force: true) }
    let(:file_path) { 'spec/fixtures/feature.tsx' }
    let(:client_matcher) do
      {
        'regex' => 'spec/fixtures/.*\.tsx',
        'test_file_suffix' => '.test.tsx',
        'root_path' => 'spec/fixtures/',
        'test_root_path' => 'tmp/codegen_spec/',
        'instructions' => 'instructions/react.md'
      }
    end

    context 'when test file does not exist' do
      it 'creates a test file and writes generated code once' do
        allow(File).to receive(:exist?).with('tmp/codegen_spec/feature.test.tsx').and_return(false)
        expect(FileUtils).to receive(:mkdir_p).with('tmp/codegen_spec')
        allow(Dotcodegen::TestCodeGenerator).to receive_message_chain(:new, :generate_test_code).and_return('Mocked generated code')
        expect(File).to receive(:write).with('tmp/codegen_spec/feature.test.tsx', '').once
        expect(File).to receive(:write).with('tmp/codegen_spec/feature.test.tsx', 'Mocked generated code').once
        subject.run
      end
    end

    context 'when test file already exists' do
      it 'does not create a test file but writes generated code' do
        allow(File).to receive(:exist?).with('tmp/codegen_spec/feature.test.tsx').and_return(true)
        expect(FileUtils).not_to receive(:mkdir_p)
        allow(Dotcodegen::TestCodeGenerator).to receive_message_chain(:new, :generate_test_code).and_return('Mocked generated code')
        expect(File).to receive(:write).with('tmp/codegen_spec/feature.test.tsx', 'Mocked generated code').once
        subject.run
      end
    end
  end

  describe '#matcher' do
    it 'returns the matching regex for the frontend' do
      expect(subject.matcher).to eq(client_matcher)
    end

    context 'when file path is a ruby file' do
      let(:file_path) { 'api/app/models/app.rb' }
      it 'returns the matching regex for the backend' do
        expect(subject.matcher).to eq(api_matcher)
      end
    end

    context 'when there are no matches' do
      let(:file_path) { 'terraform/models/app.rb' }
      it 'returns nil' do
        expect(subject.matcher).to be_nil
      end
    end

    context 'when file path does not match any regex' do
      let(:file_path) { 'api/models/app.go' }
      it 'returns nil' do
        expect(subject.matcher).to be_nil
      end
    end
  end

  describe '#test_file_path' do
    it 'returns the test file path for the frontend' do
      expect(subject.test_file_path).to eq('client/app/components/feature.test.tsx')
    end

    context 'when file path is a ruby file' do
      let(:file_path) { 'api/app/models/app.rb' }
      it 'returns the test file path for the backend' do
        expect(subject.test_file_path).to eq('api/spec/models/app_spec.rb')
      end
    end
  end
end
