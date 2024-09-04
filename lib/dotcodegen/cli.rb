# frozen_string_literal: true

require 'optparse'
require 'ostruct'
require 'front_matter_parser'
require 'fileutils'
require_relative 'test_file_generator'
require_relative 'version'
require_relative 'init'
require 'dotenv' unless defined?($running_tests) && $running_tests

module Dotcodegen
  class CLI
    def self.parse(args)
      options = OpenStruct.new
      opt_parser = build_option_parser(options)
      handle_arguments(args, opt_parser, options)
      options
    end

    def self.run(args)
      Dotenv.load unless defined?($running_tests) && $running_tests
      options = parse(args)
      return version if options.version
      return Init.run if options.init

      matchers = load_matchers('.codegen/instructions')
      TestFileGenerator.new(file_path: options.file_path, matchers:, openai_key: options.openai_key, openai_org_id: options.openai_org_id).run
    end

    def self.version
      puts "Dotcodegen version #{Dotcodegen::VERSION}"
      exit
    end

    def self.load_matchers(instructions_path)
      Dir.glob("#{instructions_path}/*.md").map do |file|
        parsed = FrontMatterParser::Parser.parse_file(file)
        parsed.front_matter.merge({ content: parsed.content })
      end
    end

    # rubocop:disable Metrics/MethodLength
    def self.build_option_parser(options)
      OptionParser.new do |opts|
        opts.banner = 'Usage: dotcodegen [options] file_path'
        opts.on('--openai_key KEY', 'OpenAI API Key') { |key| options.openai_key = key }
        opts.on('--openai_org_id Org_Id', 'OpenAI Organisation Id') { |key| options.openai_org_id = key }
        opts.on('--init', 'Initialize a .codegen configuration in the current directory') { options.init = true }
        opts.on('--version', 'Show version') { options.version = true }
        opts.on_tail('-h', '--help', 'Show this message') do
          puts opts
          exit
        end
      end
    end

    # rubocop:disable Metrics/AbcSize
    def self.handle_arguments(args, opt_parser, options)
      opt_parser.parse!(args)
      return if options.version || options.init

      validate_file_path(args, opt_parser)
      options.file_path = args.shift
      options.openai_key ||= ENV['OPENAI_KEY']
      options.openai_org_id ||= ENV['OPENAI_ORG_ID']

      return unless options.openai_key.to_s.strip.empty?

      puts 'Error: Missing --openai_key flag or OPENAI_KEY environment variable.'

      puts opt_parser
      exit 1
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    def self.validate_file_path(args, opt_parser)
      return unless args.empty?

      puts 'Error: Missing file path.'
      puts opt_parser
      exit 1
    end
  end
end
