require 'spec_helper'
require 'thor'
load file_path('lib/tasks/parser.thor')

RSpec.describe HelloLabs::Parser do
  let(:dictionary) { file_path('spec/input/dictionary.txt') }
  let(:words) { file_path('spec/output/words.txt') }
  let(:sequences) { file_path('spec/output/sequences.txt') }

  subject { described_class.new }

  before do
    File.delete words if File.file?(words)
    File.delete sequences if File.file?(sequences)
    subject.options = {}
  end

  describe '#parse' do
    context 'file creation and options(flags)' do
      before do
        subject.options[:input_file] = dictionary
      end

      context 'with no output files present' do
        before do
          subject.options[:output_dir] = file_path('spec/output')
          subject.parse
        end

        it 'creates files' do
          expect(File.exist?(words)).to equal true
          expect(File.exist?(sequences)).to equal true
        end
      end

      context 'with existing output files' do
        before do
          File.open(words, 'w') {}
          File.open(sequences, 'w') {}
          subject.options[:output_dir] = file_path('spec/output')
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
    end

    context 'file content' do
      # TODO: test output file contents
    end
  end
end
