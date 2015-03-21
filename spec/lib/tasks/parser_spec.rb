require 'spec_helper'
require File.expand_path('../../../spec/support/file_path', File.dirname(__FILE__))
require 'thor'
load file_path('lib/tasks/parser.thor')

RSpec.describe HelloLabs::Parser do
  let(:words) { file_path('spec/output/words.txt') }
  let(:sequences) { file_path('spec/output/sequences.txt') }

  subject { described_class.new }

  before do
    File.delete words
    File.delete sequences
    subject.options = {}
  end

  describe '#parse' do
    describe 'file creation and options(flags)' do
      context 'with file option specified' do
        before do
          subject.options[:input_file] = file_path('input/dictionary.txt')
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
            contents = File.read(words)
            expect(contents).not_to be_empty
            contents = File.read(sequences)
            expect(contents).not_to be_empty
          end

          it 'cancels without --f flag' do
            subject.parse

            # file content should still be empty:
            contents = File.read(words)
            expect(contents).to be_empty
            contents = File.read(sequences)
            expect(contents).to be_empty
          end
        end
      end
    end

    describe 'file content' do
      # TODO: test output file contents
    end
  end
end
