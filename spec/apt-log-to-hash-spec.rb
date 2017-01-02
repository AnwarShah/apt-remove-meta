require 'spec_helper'
require_relative '../lib/apt-log-to-hash'
include AptLogToHash

# no of sections in the referenced history.log file

RSpec.describe AptLogToHash, type: 'module' do
  let(:log_file_loc) { 'history.log' }
  let(:log_file_content) { File.open(log_file_loc) { |f| f.read } }
  let(:sections_in_file) { 12 }

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
      let(:file_content) { log_file_content }

      it "returns it's content" do
        content = read_file(log_file_loc)
        expect(content).to eq file_content
      end
    end
  end

  describe '#parse_into_hash method' do
    let(:file_content) { log_file_content }
    let(:output) { parse_into_hash file_content }

    it "takes the file content as argument" do
      expect { parse_into_hash }.to raise_error(ArgumentError)
    end
    it "returns an Array of Hash" do
      expect(output).to be_kind_of Array
      expect {output.all? { |c| c.class == Hash } }
    end
    it "returns Array with 'no of sections' hashes" do
      expect(output.size).to eq sections_in_file
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

  describe "#is_gzip_file? method" do
    it "takes a filename with path as argument" do
      expect { is_gzip_file? }.to raise_error(ArgumentError, /0 for 1/)
    end

    it "returns true if a filename ends with .gz or .gzip" do
      expect( is_gzip_file?("history.log") ).to be false
      expect(is_gzip_file?("history.log.gz")).to be true
      expect(is_gzip_file?("history.log.gzip")).to be true
    end
  end

  describe "#read_gzip_file method" do
    it "reads gzip file and returns it's content" do
      content = read_gzip_file(log_file_loc + '.gz')
      expect(content).to eq log_file_content
    end
  end
end
