# frozen_string_literal: true

require 'openai'
require_relative 'format_output'

module Dotcodegen
  class TestCodeGenerator
    attr_reader :config, :file_to_test_path, :openai_key, :openai_org_id

    def initialize(config:, file_to_test_path:, openai_key:, openai_org_id: nil)
      @config = config
      @file_to_test_path = file_to_test_path
      @openai_key = openai_key
      @openai_org_id = openai_org_id
    end

    def generate_test_code
      response = openai_client.chat(
        parameters: {
          model: 'gpt-4o',
          messages: [{ role: 'user', content: test_prompt_text }], # Required.
          response_format: { type: "json_object" },
          temperature: 0.7
        }
      )
      FormatOutput.format(response.dig('choices', 0, 'message', 'content'))
    end

    def test_prompt_text
      [{ "type": 'text', "text": test_prompt }]
    end

    # rubocop:disable Metrics/MethodLength
    def test_prompt
      [
        'You are an expert programmer. You have been given a task to write a test file for a given file following some instructions.',
        'This is the file you want to test:',
        '--start--',
        test_file_content,
        '--end--',
        'Here are the instructions on how to write the test file:',
        '--start--',
        test_instructions,
        '--end--',
        "Your answer will be directly written in the file you want to test. Don't include any explanation or comments in your answer that isn't code.",
        'You can use the comment syntax to write comments in your answer.'
      ].join("\n")
    end
    # rubocop:enable Metrics/MethodLength

    def test_file_content
      File.open(file_to_test_path).read
    end

    def test_instructions
      config['content']
    end

    def openai_client
      client_options = { access_token: openai_key }
      client_options[:organization_id] = openai_org_id unless openai_org_id.nil?
      @openai_client ||= OpenAI::Client.new(client_options)
    end
  end
end
