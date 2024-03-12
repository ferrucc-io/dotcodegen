# frozen_string_literal: true

require 'dotcodegen/test_code_generator'

RSpec.describe Dotcodegen::TestCodeGenerator do
  let(:config) do
    {
      'regex' => 'spec/fixtures/.*\.rb',
      'test_file_suffix' => '_spec.rb',
      'content' => 'Be a very good coder and write a very good test'
    }
  end
  let(:file_to_test_path) { 'spec/fixtures/labels_controller.rb' }
  let(:openai_key) { 'test_openai_key' }
  let(:openai_org_id) { 'test_openai_org_id' }
  let(:code_generator_instance) do
    described_class.new(config:, file_to_test_path:, openai_key:)
  end

  describe '#test_prompt' do
    it 'returns a correctly formatted prompt with file content and instructions' do
      file_content = File.read(file_to_test_path)
      instructions_content = config['content']
      expected_prompt = [
        'You are an expert programmer. You have been given a task to write a test file for a given file following some instructions.',
        'This is the file you want to test:',
        '--start--',
        file_content,
        '--end--',
        'Here are the instructions on how to write the test file:',
        '--start--',
        instructions_content,
        '--end--',
        "Your answer will be directly written in the file you want to test. Don't include any explanation or comments in your answer that isn't code.",
        'You can use the comment syntax to write comments in your answer.'
      ].join("\n")

      expect(code_generator_instance.test_prompt).to eq(expected_prompt)
    end
  end

  describe '#generate_test_code' do
    it 'mocks the OpenAI response and checks the generated code' do
      mock_response = { 'choices' => [{ 'message' => { 'content' => 'Mocked generated code' } }] }
      allow_any_instance_of(OpenAI::Client).to receive(:chat).and_return(mock_response)
      expect(code_generator_instance.generate_test_code).to eq('Mocked generated code')
    end
  end
end
