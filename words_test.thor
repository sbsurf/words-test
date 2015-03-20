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
      process_file file
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
    output = {}
    dupes = []

    File.readlines(file).each do |line|
      next if line.length < 4

      line_words = []

      for i in 0..line.length - 1
        next if i + 1 > line.length - 4

        sub_line = line[i..i+3]
        line_words << sub_line if sub_line == sub_line[/[a-zA-Z]+/]
        line_words.uniq!
      end

      line_words.each do |word|
        if output.has_key?(word)
          dupes << word
          next
        else
          output[word] = line
        end
      end
    end

    # clean up remaining dupes:
    dupes.uniq!.each do |word|
      output.delete word
    end

    create_files(output)
  end

  def create_files(output)
    words = File.new('output/words.txt', 'w')
    sequences = File.new('output/sequences.txt', 'w')

    output.each do |key, value|
      # puts "#{key.to_s}: #{value.to_s}"
      sequences.puts(key.to_s)
      words.puts(value.to_s)
    end

    sequences.close
    words.close
  end

  def output_files_exist?
    File.file?('output/sequences.txt') || File.file?('output/words.txt') ? true : false
  end
end
