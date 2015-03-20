class WordsTest < Thor
  desc 'parse FILE', "parses specified file, and generates two output files: 'sequences.txt' and 'words.txt'."
  def parse(file)
    puts "You supplied the file: #{file}"
  end
end
