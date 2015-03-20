class WordsTest < Thor
  desc 'parse -f FILE', "Parses specified file (or input/dictionary.txt), and generates two output files: 'sequences.txt' and 'words.txt'."
  method_option :f, type: :string, aliases: 'f', default: 'input/dictionary.txt' # input file

  # TODO: add tests
  # TODO: add more error handling
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

  # TODO: consider factoring out into a Module
  def process_file(file)
    output = {}
    dupes = []

    File.readlines(file).each do |line|
      next if line.length < 4

      find_sequences(line).each do |sequence|
        if output.has_key?(sequence)
          dupes << sequence
          next
        else
          output[sequence] = line
        end
      end
    end

    final_output = clean_up_dupes(dupes, output)
    create_files(final_output)
  end

  # creates a unique array of 4-char alpha strings for each line:
  def find_sequences(line)
    sequences = []

    (0..(line.length - 1)).each do |i|
      next if i + 1 > line.length - 4

      sub_line = line[i..i+3]
      sequences << sub_line if sub_line == sub_line[/[a-zA-Z]+/]
    end

    sequences.uniq
  end

  def clean_up_dupes(dupes, output)
    dupes.uniq!.each do |sequence|
      output.delete sequence
    end

    output
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
