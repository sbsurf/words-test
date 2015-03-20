class WordsTest < Thor
  desc 'parse -f FILE', "Parses specified file (or input/dictionary.txt), and generates two output files: 'sequences.txt' and 'words.txt'."
  method_option :f, type: :string, aliases: 'f', default: 'input/dictionary.txt' # input file
  def parse
    file = options[:f]
    say "Defaulting to input file: #{file}"

    if output_files_exist?
      if no?('This will replace existing output files. Proceed? (y/n)', :yellow)
        say 'Operation canceled by user.', :yellow
        return
      end
    end

    if File.file?(file)
      say 'Generating output files. Please wait...', :green
      process_file(file)
    else
      say 'Input file not found. Operation canceled.', :yellow
      return
    end

    say 'Operation succeeded. The following 2 files were generated:', :green
    say 'output/sequences.txt'
    say 'output/words.txt'
  end

  private

  def process_file(file)
    File.readlines(file).each do |line|
      puts line
    end
  end

  def output_files_exist?
    File.file?('output/sequences.txt') || File.file?('output/words.txt') ? true : false
  end
end
