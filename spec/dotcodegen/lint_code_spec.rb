# frozen_string_literal: true

require 'dotcodegen/lint_code'
require 'tempfile'

RSpec.describe Dotcodegen::LintCode do
  let!(:file_path) { 'path/to/test/file.rb' }
  subject(:lint_code) { described_class.new(file_path:) }

  before do
    allow(Gem::Specification).to receive(:find_by_name).and_call_original
    allow(lint_code).to receive(:system)
  end


  describe '#run' do
    context 'when StandardRB gem only is available' do
      it 'runs StandardRB linting command' do
        allow(lint_code).to receive(:gem_available?).with('standard').and_return(true)
        allow(lint_code).to receive(:gem_available?).with('rubocop').and_return(false)
        expect(lint_code).to receive(:system).with(any_args).exactly(1).times
        lint_code.run
      end
    end

    context 'when RuboCop gem only is available and .rubocop.yml exists' do
      it 'runs RuboCop linting command' do
        allow(lint_code).to receive(:gem_available?).with('standard').and_return(false)
        allow(lint_code).to receive(:gem_available?).with('rubocop').and_return(true)
        allow(lint_code).to receive(:rubocop_config_exists?).and_return(true)
        expect(lint_code).to receive(:system).with(any_args).exactly(1).times
        lint_code.run
      end
    end

    context 'when RuboCop gem only is available but .rubocop.yml does not exists' do
      it 'runs RuboCop linting command' do
        allow(lint_code).to receive(:gem_available?).with('standard').and_return(false)
        allow(lint_code).to receive(:gem_available?).with('rubocop').and_return(true)
        allow(lint_code).to receive(:rubocop_config_exists?).and_return(false)
        expect(lint_code).not_to receive(:system)
        lint_code.run
      end
    end

    context 'when both RuboCop(with its config file) and StandardRB Exists' do
      it 'runs only one of them' do
        allow(lint_code).to receive(:gem_available?).with('standard').and_return(true)
        allow(lint_code).to receive(:gem_available?).with('rubocop').and_return(true)
        allow(lint_code).to receive(:rubocop_config_exists?).and_return(true)
        expect(lint_code).to receive(:system).with(any_args).exactly(1).time
        lint_code.run
      end
    end

    context 'when neither RuboCop or Standard Exist' do
      it 'runs both linting commands' do
        allow(lint_code).to receive(:gem_available?).with(any_args).and_return(false)
        expect(lint_code).to receive(:system).with(any_args).exactly(0).times
        lint_code.run
      end
    end
  end

  describe '#gem_available?' do
    context 'when a gem is available' do
      it 'returns true' do
        allow(Gem::Specification).to receive(:find_by_name).with('standard').and_return(true)
        expect(lint_code.gem_available?('standard')).to be true
      end
    end

    context 'when a gem is not available' do
      it 'returns false' do
        allow(Gem::Specification).to receive(:find_by_name).with('nonexistent').and_raise(Gem::LoadError)
        expect(lint_code.gem_available?('nonexistent')).to be false
      end
    end
  end

  describe '#rubocop_config_exists?' do
    it 'returns true if .rubocop.yml exists' do
      allow(File).to receive(:exist?).with('.rubocop.yml').and_return(true)
      expect(lint_code.rubocop_config_exists?).to be true
    end

    it 'returns false if .rubocop.yml does not exist' do
      allow(File).to receive(:exist?).with('.rubocop.yml').and_return(false)
      expect(lint_code.rubocop_config_exists?).to be false
    end
  end

  describe '#ruby_supported?' do
    let(:ruby_file_checker) { described_class.new(file_path: 'example.rb') }
    let(:non_ruby_file_checker) { described_class.new(file_path: 'example.txt') }

    it 'returns true for a file path ending with .rb' do
      expect(ruby_file_checker.ruby_supported?).to be(true)
    end

    it 'returns false for a file path not ending with .rb' do
      expect(non_ruby_file_checker.ruby_supported?).to be(false)
    end
  end

  describe '#lints_file_as_expected' do
    # Rubucop likes to put magic comment # frozen_string_literal: true at the top of files for performace
    # Rubucop likes single quotes be used when string interpolation is not needed
    # Standardrb instead, likes double quotes always for strings
    it "standardrb" do
      Tempfile.create(['tempfile_', '.rb']) do |tempfile|
        initial_content = <<~RUBY
          greeting = "Hello, world!"
          name = "Alice"
          puts "\#{greeting} I'm \#{name}."
        RUBY

        expected_content = <<~RUBY
          greeting = "Hello, world!"
          name = "Alice"
          puts "\#{greeting} I'm \#{name}."
          RUBY

        tempfile.write(initial_content)
        tempfile.close

        instance = described_class.new(file_path: tempfile.path)

        allow(instance).to receive(:gem_available?).with('rubocop').and_return(false)
        allow(instance).to receive(:gem_available?).with('standard').and_return(true)
        
        instance.run

        actual_content = File.read(tempfile.path)
        expect(actual_content).to eq(expected_content) 
      end
    end

    it "standardrb but on none ruby file" do
      Tempfile.create(['tempfile_', '.js']) do |tempfile|
        initial_content = <<~RUBY
          greeting = "Hello, world!"
          name = "Alice"
          puts "\#{greeting} I'm \#{name}."
        RUBY

        tempfile.write(initial_content)
        tempfile.close

        instance = described_class.new(file_path: tempfile.path)

        allow(instance).to receive(:gem_available?).with('rubocop').and_return(false)
        allow(instance).to receive(:gem_available?).with('standard').and_return(true)
        
        instance.run

        actual_content = File.read(tempfile.path)
        expect(actual_content).to eq(initial_content)
      end
    end

    it "rubocop" do
      Tempfile.create(['tempfile_', '.rb']) do |tempfile|
        initial_content = <<~RUBY
          greeting = "Hello, world!"
          name = "Alice"
          puts "\#{greeting} I'm \#{name}."
        RUBY

        expected_content = <<~RUBY
          \# frozen_string_literal: true

          greeting = 'Hello, world!'
          name = 'Alice'
          puts "\#{greeting} I'm \#{name}."
          RUBY

        tempfile.write(initial_content)
        tempfile.close

        instance = described_class.new(file_path: tempfile.path)

        allow(instance).to receive(:gem_available?).with('rubocop').and_return(true)
        allow(instance).to receive(:gem_available?).with('standard').and_return(false)
        allow(instance).to receive(:rubocop_config_exists?).and_return(true)
        
        instance.run

        actual_content = File.read(tempfile.path)
        expect(actual_content).to eq(expected_content) # Use strip to remove any leading/trailing whitespace
      end
    end
  end
end