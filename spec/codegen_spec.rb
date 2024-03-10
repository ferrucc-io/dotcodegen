# frozen_string_literal: true

require 'dotcodegen/test_file_generator'

RSpec.describe 'Main Script' do
  let(:file_path) { 'client/app/components/feature.tsx' }
  let(:openai_key) { 'test_openai_key' }
  let(:codegen_instance) { instance_double(Dotcodegen::TestFileGenerator) }

  before do
    allow(Dotcodegen::TestFileGenerator).to receive(:new).and_return(codegen_instance)
    allow(codegen_instance).to receive(:run)
  end

  it 'initializes and runs the TestFileGenerator with the provided file path, matchers including content, and openai key' do
    ARGV.replace([file_path, '--openai_key', openai_key])
    load 'exe/codegen'
    expect(Dotcodegen::TestFileGenerator).to have_received(:new).with(hash_including(file_path: file_path, openai_key: openai_key))
    expect(codegen_instance).to have_received(:run)
  end

  it 'exits with an error message when the openai_key flag is missing and OPENAI_KEY environment variable is not set' do
    ARGV.replace([file_path])
    expect { load 'exe/codegen' }
      .to output(a_string_including("Error: Missing --openai_key flag or OPENAI_KEY environment variable.")).to_stdout
      .and raise_error(SystemExit)
  end

  context 'when the openai_key flag is missing and the OPENAI_KEY environment variable is set' do
    before do
      ENV['OPENAI_KEY'] = openai_key
    end

    it 'initializes and runs the TestFileGenerator with the provided file path, matchers including content, and openai key' do
      ARGV.replace([file_path])
      load 'exe/codegen'
      expect(Dotcodegen::TestFileGenerator).to have_received(:new).with(hash_including(file_path: file_path, openai_key: openai_key))
      expect(codegen_instance).to have_received(:run)
    end
  end
end
