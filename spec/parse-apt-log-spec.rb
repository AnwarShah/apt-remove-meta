require 'spec_helper'
require_relative '../parse-apt-log.rb'

RSpec.describe "#read_file_into_hash" do
  context("when called without any argument") do
    it "raises ArgumentError exception" do
      expect {read_file_into_hash()}.to raise_error(ArgumentError)
    end
  end
  
  context("when an invalid filename is given as argument") do
    it "raises ArgumentError with message 'Invalid filename'" do
      expect { read_file_into_hash('no_file') }.to raise_error(ArgumentError, /Invalid filename/)
    end
  end

  context("when valid filename is given as argument") do
    it "returns a Array of Hash" do
      output = read_file_into_hash('history.log')
      expect(output).to be_kind_of Array
      expect {output.all? { |c| c.class == Hash } }
    end
  end
end
