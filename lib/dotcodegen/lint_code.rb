# frozen_string_literal: true

module Dotcodegen
  class LintCode
    def initialize(file_path:)
      @file_path = file_path
    end

    def run
      if gem_available?('standard')
        standardrb_code
      end

      # Attempt to lint with RuboCop if the gem is available and .rubocop.yml exists
      # StandardRB includes Rubocop by default. Hence the presence of .rubocop.yml is best indication that Rubocop is in active use
      if gem_available?('rubocop') && rubocop_config_exists?
        rubocop_code
      end
    end


    def standardrb_code
      puts "Linting: StandardRB"
      system("standardrb --fix-unsafely #{@file_path}")
    end

    def rubocop_code
      puts "Linting: Rubocop"
      system("rubocop --autocorrect-all --disable-pending-cops #{@file_path}")
    end

    def gem_available?(name)
      Gem::Specification.find_by_name(name)
    rescue Gem::LoadError
      false
    end

    # Function to check for .rubocop.yml configuration file
    def rubocop_config_exists?
      File.exist?('.rubocop.yml')
    end
  end
end
