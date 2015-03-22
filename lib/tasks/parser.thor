require 'thor'
require 'wannabe_bool'
require './lib/words_test.rb'

module HelloLabs
  class Parser < Thor
    include WordsTest

    desc 'parse -i input_file -o output_dir -f overwrite ', "Parses specified file (or input/dictionary.txt), and generates two output files: 'sequences.txt' and 'words.txt'."
    method_option :input_file, type: :string, aliases: 'i', default: 'input/dictionary.txt' # input file
    method_option :output_dir, type: :string, aliases: 'o', default: 'output' # input file
    method_option :overwrite, type: :string, aliases: 'f', default: 'no' # overwrites existing output files

    def parse
      file = options[:input_file]
      output_dir = options[:output_dir]

      say "Using input file: #{file}"

      if output_files_exist?(output_dir) && !options[:overwrite].to_b
        say 'Output files exist. Set the -f option to overwrite. Operation canceled.', :yellow
        return
      end

      if File.file?(file) && !File.zero?(file)
        say 'Generating output files. Please wait...', :green
        process_file(file, output_dir)
      else
        say 'Input file not found or is empty. Operation canceled.', :yellow
        return
      end

      say 'Operation succeeded. The following 2 files were generated:', :green
      say "#{output_dir}/sequences.txt"
      say "#{output_dir}/words.txt"
    end
  end
end
