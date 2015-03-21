module WordsTest
  def process_file(file, output_dir)
    output = {}
    dupes = []

    File.readlines(file).each do |line|
      next if line.length < 4

      find_sequences(line).each do |sequence|
        if output.key?(sequence)
          dupes << sequence
          next
        else
          output[sequence] = line
        end
      end
    end

    final_output = clean_up_dupes(dupes, output)
    create_files(final_output, output_dir)
  end

  # creates a unique array of 4-char alpha strings for each line:
  def find_sequences(line)
    sequences = []

    (0..(line.length - 1)).each do |i|
      next if i + 1 > line.length - 4

      sub_line = line[i..i + 3]
      sequences << sub_line if sub_line == sub_line[/[a-zA-Z]+/]
    end

    sequences.uniq
  end

  def clean_up_dupes(dupes, output)
    unless dupes.empty?
      dupes.uniq.each do |sequence|
        output.delete sequence
      end
    end

    output
  end

  def create_files(output, dir)
    words = File.new("#{dir}/words.txt", 'w')
    sequences = File.new("#{dir}/sequences.txt", 'w')

    output.each do |key, value|
      sequences.puts(key.to_s)
      words.puts(value.to_s)
    end

    sequences.close
    words.close
  end

  def output_files_exist?(dir)
    File.file?("#{dir}/sequences.txt") || File.file?("#{dir}/words.txt") ? true : false
  end
end
