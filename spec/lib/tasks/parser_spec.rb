require 'spec_helper'
require 'thor'
require 'fileutils'
load file_path('lib/tasks/parser.thor')

RSpec.describe HelloLabs::Parser do
  let(:dictionary) { file_path('spec/input/dictionary.txt') }
  let(:dictionary_temp) { file_path('spec/input/dictionary_temp.txt') }
  let(:words) { file_path('spec/output/words.txt') }
  let(:sequences) { file_path('spec/output/sequences.txt') }

  subject { described_class.new }

  before do
    subject.options = {}
    subject.options[:output_dir] = file_path('spec/output')
  end

  describe '#parse' do
    context 'file creation and options(flags)' do
      before do
        File.delete words if File.file?(words)
        File.delete sequences if File.file?(sequences)
      end

      context 'input' do
        context 'specified input file exists' do
          before do
            subject.options[:input_file] = dictionary_temp
            File.open(dictionary_temp, 'w') {}
          end

          after do
            File.delete dictionary_temp if File.file?(dictionary_temp)
          end

          it 'does not continue if input file empty' do
            subject.parse

            expect(File.file?(words)).to equal false
            expect(File.file?(sequences)).to equal false
          end

          it 'continues if input file not empty' do
            File.write(dictionary_temp, 'teststring')
            subject.parse

            expect(File.file?(words)).to equal true
            expect(File.file?(sequences)).to equal true
          end
        end

        context 'specified input file does not exist' do
          before do
            subject.options[:input_file] = dictionary_temp
          end

          it 'does not continue' do
            subject.parse

            expect(File.file?(words)).to equal false
            expect(File.file?(sequences)).to equal false
          end
        end
      end

      context 'output' do
        before do
          subject.options[:input_file] = dictionary
        end

        context 'with no output files present' do
          before do
            subject.parse
          end

          it 'creates files' do
            expect(File.file?(words)).to equal true
            expect(File.file?(sequences)).to equal true
          end
        end

        context 'with existing output files' do
          before do
            File.open(words, 'w') {}
            File.open(sequences, 'w') {}
          end

          it 'overwrites files with --f flag' do
            subject.options[:overwrite] = true
            subject.parse

            # file content should not be empty anymore:
            expect(File.size?(words)).to be_truthy
            expect(File.size?(sequences)).to be_truthy
          end

          it 'cancels without --f flag' do
            subject.parse

            # file content should still be empty:
            expect(File.size?(words)).to_not be_truthy
            expect(File.size?(sequences)).to_not be_truthy
          end
        end

        context 'when non-existing output directory is specified' do
          before do
            subject.options[:output_dir] = file_path('spec/output_temp')
            subject.parse
          end

          after do
            FileUtils.remove_dir('spec/output_temp')
          end

          it 'creates directory' do
            expect(Dir.exists?('spec/output_temp')).to equal true
          end
        end
      end
    end

    context 'file content' do
      before do
        subject.options[:input_file] = dictionary
        subject.options[:overwrite] = true
        subject.parse
      end

      it 'splits words into 4-char sequences' do
        File.readlines(sequences).each do |line|
          fail 'Incorrect sequence length' unless line.strip.length == 4
        end
      end

      it 'removes duplicate sequences' do
        expect(File.readlines(sequences).uniq!).to be_nil
      end

      it 'properly handles non-alpha characters' do
        seqs = File.readlines(sequences)

        expect(seqs).not_to include("1234\n")
        expect(seqs).not_to include("99Gr\n")
        expect(seqs).not_to include("zky!\n")
        expect(seqs).not_to include("O\'Co\n")
        expect(seqs).not_to include("OCon\n")
        expect(seqs).to include("Gret\n")
        expect(seqs).to include("tzky\n")
        expect(seqs).to include("Conn\n")
      end

      it 'distinguishes between upper and lower case' do
        seqs = File.readlines(sequences)
        expect(seqs).to include("Aaro\n")
        expect(seqs).to include("aaro\n")
      end

      it 'creates same number of lines in each output file' do
        expect(File.readlines(sequences).count).to equal File.readlines(words).count
      end

      it 'puts sequence on same line number as its corresponding word' do
        seqs = File.readlines(sequences)
        wrds = File.readlines(words)

        seqs.each_with_index do |seq, index|
          fail 'Lines don\'t match' unless wrds[index].include?(seq.strip)
        end
      end
    end
  end
end
