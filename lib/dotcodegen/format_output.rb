# frozen_string_literal: true

module Dotcodegen
  class FormatOutput
    def self.format(generated_test_code)
      generated_test_code.gsub(/^```[a-zA-Z]*\n/, '').gsub(/\n```$/, '')
    end
  end
end
