require 'spec_helper'
require_relative '../apt-log-to-hash'
require_relative '../parse-apt-log'
include AptLogToHash

# no of sections in the referenced history.log file
SECTIONS_IN_FILE=12

RSpec.describe AptLogToHash, type: 'module' do
  describe "#read_file method" do
    context("when called without any argument") do
      it "raises ArgumentError exception" do
        expect {read_file()}.to raise_error(ArgumentError)
      end
    end

    context("when an invalid filename is given as argument") do
      it "raises ArgumentError with message 'Invalid filename'" do
        expect { read_file('no_file') }.to raise_error(ArgumentError, /Invalid filename/)
      end
    end

    context("when valid filename is given as argument") do
      let(:file_content) { "This is the content of the file" }

      it "calls File.read with filename argument and return it's content" do
        f = double('file') { File }
        allow(f).to receive(:read).and_return(file_content)
        read_file('history.log') # call the method
      end
    end
  end

  describe '#parse_into_hash method' do
    let(:file_content) { read_file('history.log') }
    let(:output) { parse_into_hash file_content }

    it "takes the file content as argument" do
      expect { parse_into_hash }.to raise_error(ArgumentError)
    end
    it "returns an Array of Hash" do
      expect(output).to be_kind_of Array
      expect {output.all? { |c| c.class == Hash } }
    end
    it "returns Array with 'no of sections' hashes" do
      expect(output.size).to eq SECTIONS_IN_FILE
    end
    describe("each returned hash") do
      let(:opt_keys) { ["Install", "Reinstall", "Purge", "Upgrade", "Remove"] }
      it "contains 'Commandline' key" do
        expect(output.all? { |c| c.key?("Commandline") } ).to be true
      end
      it "contains 'Start-Date' key" do
        expect(output.all? { |c| c.key?("Start-Date") }).to be true
      end
      it "contains 'End-Date' key" do
        expect(output.all? { |c| c.key?("End-Date") }).to be true
      end
      it "contains at least one of the 'Install, Reinstall, Purge, Upgrade, Remove' key" do
        expect(output.all? { |c| c.keys.any? {|k| opt_keys.include?(k)} }).to be true
      end
    end
  end
end
