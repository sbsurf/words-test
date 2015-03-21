require 'thor'
require 'wannabe_bool'
require './lib/words_test.rb'

module HelloLabs
  class Parser < Thor
    include WordsTest

    desc 'parse -f FILE', "Parses specified file (or input/dictionary.txt), and generates two output files: 'sequences.txt' and 'words.txt'."
    method_option :input_file, type: :string, aliases: 'i', default: 'input/dictionary.txt' # input file
    method_option :output_dir, type: :string, aliases: 'o', default: 'output' # input file
    method_option :overwrite, type: :string, aliases: 'f', default: false # overwrites existing output files

    # TODO: add more error handling
    def parse
      file = options[:input_file]
      say "Using input file: #{file}"

      if output_files_exist?(options[:output_dir]) && !options[:overwrite].to_b
        say 'Output files exist. Set the -f option to overwrite. Operation canceled.', :yellow
        return
      end

      if File.file?(file) || !File.zero?(file)
        say 'Generating output files. Please wait...', :green
        process_file(file, options[:output_dir])
      else
        say 'Input file not found or is empty. Operation canceled.', :yellow
        return
      end

      say 'Operation succeeded. The following 2 files were generated:', :green
      say 'output/sequences.txt'
      say 'output/words.txt'
    end
  end
end
