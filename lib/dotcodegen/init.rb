# frozen_string_literal: true

module Dotcodegen
  class Init
    # rubocop:disable Metrics/MethodLength
    def self.run
      source_dir = File.expand_path('../../config/default/.codegen', __dir__)
      destination_dir = File.expand_path('.codegen', Dir.pwd)

      FileUtils.mkdir_p(destination_dir) unless Dir.exist?(destination_dir)
      FileUtils.cp_r("#{source_dir}/.", destination_dir)

      instructions_dir = File.expand_path('instructions', destination_dir)
      FileUtils.mkdir_p(instructions_dir) unless Dir.exist?(instructions_dir)

      Dir.glob("#{source_dir}/instructions/*.md").each do |md_file|
        FileUtils.cp(md_file, instructions_dir)
      end

      puts 'Codegen initialized.'
      exit
    end
    # rubocop:enable Metrics/MethodLength
  end
end
