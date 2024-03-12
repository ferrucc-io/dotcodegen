# frozen_string_literal: true

require 'dotcodegen/format_output'

RSpec.describe Dotcodegen::FormatOutput do
  describe '.format_test_code' do
    it 'formats the generated test code by removing markdown code block syntax and leading/trailing spaces' do
      expect(Dotcodegen::FormatOutput.format("```ruby\nformatted_code\n```")).to eq('formatted_code')
    end

    it 'formats typescript code' do
      expect(Dotcodegen::FormatOutput.format("```typescript\nformatted_code\n```")).to eq('formatted_code')
    end

    it 'formats python code' do
      expect(Dotcodegen::FormatOutput.format("```python\nformatted_code\n```")).to eq('formatted_code')
    end

    context 'when the test code does not contain markdown code block syntax' do
      it 'returns the test code as is' do
        expect(Dotcodegen::FormatOutput.format('formatted_code')).to eq('formatted_code')
      end
    end
  end
end