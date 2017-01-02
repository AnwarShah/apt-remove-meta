require 'spec_helper'
require_relative '../apt-log-to-hash'
require_relative '../parse-apt-log'
include AptLogToHash

FILE_CONTENT = File.open('history.log') { |f| f.read }

RSpec.describe "#find_in_commands method" do
  let(:file_content)  { FILE_CONTENT }
  let(:content_hash_arr) { parse_into_hash(file_content) }

  context("when 2 arguments aren't passed") do
    it "raises ArgumentError" do
      expect { find_in_commands }.to raise_error(ArgumentError, /0 for 2/)
      expect { find_in_commands('content') }.to raise_error(ArgumentError, /1 for 2/)
    end
  end

  context("when two arguments are passed") do
    let(:outputs) { find_in_commands(content_hash_arr, 'pantheon') }
    let(:empty_output) { find_in_commands(content_hash_arr, 'heelo') }

    context("with valid search_term") do
      context("if any section's command matches") do
        it "returns an array of hashes" do
          expect(outputs).to be_kind_of(Array)
          outputs.each do |output|
            expect(output).to be_kind_of Hash
          end
        end
        it "the number of hashes equal to the section matches" do
          expect(outputs.size).to eq 1
          expect(find_in_commands(content_hash_arr, 'ttf-mscorefonts-installer').size).to eq 3
        end
      end
      context("if no section's command matches") do
        it "returns an empty array" do
          expect(empty_output).to eq []
        end
      end
    end
    context("with empty search_term") do
      it "returns empty array" do
        expect(find_in_commands(content_hash_arr, '')).to eq []
      end
    end
  end
end

RSpec.describe "#read_apt_logs" do
  it "reads apt log files from /var/log/apt dir" do
    allow(self).to receive(:read_file)
    read_apt_logs
  end
end