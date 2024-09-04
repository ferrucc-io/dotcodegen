# frozen_string_literal: true

require 'fileutils'
require_relative 'test_code_generator'
require_relative 'lint_code'

module Dotcodegen
  class TestFileGenerator
    attr_reader :file_path, :matchers, :openai_key, :openai_org_id

    def initialize(file_path:, matchers:, openai_key:, openai_org_id: nil)
      @file_path = file_path
      @matchers = matchers
      @openai_key = openai_key
      @openai_org_id = openai_org_id
    end

    def run
      Rails.logger.info "Finding matcher for #{file_path}..."
      return Rails.logger.info("No matcher found for #{file_path}") unless matcher

      Rails.logger.info "Test file path: #{test_file_path}"
      ensure_test_file_presence

      write_generated_code_to_test_file
      open_test_file_in_editor unless $running_tests

      Rails.logger.info 'Running codegen...'
    end

    def ensure_test_file_presence
      Rails.logger.info "Creating test file if it doesn't exist..."
      return if File.exist?(test_file_path)

      FileUtils.mkdir_p(File.dirname(test_file_path))
      File.write(test_file_path, '')
    end


    def write_generated_code_to_test_file
      generated_code = Dotcodegen::TestCodeGenerator.new(config: matcher,
                                                         file_to_test_path: file_path,
                                                         openai_key:,
                                                         openai_org_id:).generate_test_code
      File.write(test_file_path, generated_code)
      
      Dotcodegen::LintCode.new(file_path: test_file_path).run
    end

    def open_test_file_in_editor
      system("code #{test_file_path}")
    end

    def matcher
      @matcher ||= matchers.find { |m| file_path.match?(m['regex']) }
    end

    def test_file_path
      @test_file_path ||= "#{test_root_path}#{relative_file_name}#{test_file_suffix}"
    end

    def relative_file_name
      file_path.sub(root_path, '').sub(/\.\w+$/, '')
    end

    def test_root_path
      matcher['test_root_path'] || ''
    end

    def root_path
      matcher['root_path'] || ''
    end

    def test_file_suffix
      matcher['test_file_suffix'] || ''
    end
  end
end
