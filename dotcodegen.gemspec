# frozen_string_literal: true

require_relative 'lib/dotcodegen/version'

Gem::Specification.new do |spec|
  spec.name = 'dotcodegen'
  spec.version = Dotcodegen::VERSION
  spec.authors = ['Ferruccio Balestreri']
  spec.email = ['ferruccio.balestreri@gmail.com']

  spec.summary = 'Generate tests for your code using LLMs.'
  spec.description = 'Generate tests for your code using LLMs. This gem is a CLI tool that uses OpenAI to generate test code for your code. It uses a configuration file to match files with the right test code generation instructions. It is designed to be used with Ruby on Rails, but it can be used with any codebase. It is a work in progress.'
  spec.homepage = 'https://github.com/ferrucc-io/dotcodegen'
  spec.license = 'MIT'
  spec.required_ruby_version = '= 3.3.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/ferrucc-io/dotcodegen'
  spec.metadata['changelog_uri'] = 'https://github.com/ferrucc-io/dotcodegen/blob/main/CHANGELOG.md'

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ /lib test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'dotenv'
  spec.add_dependency 'front_matter_parser'
  spec.add_dependency 'optparse'
  spec.add_dependency 'ostruct'
  spec.add_dependency 'ruby-openai'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
