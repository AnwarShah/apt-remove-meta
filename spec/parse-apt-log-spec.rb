require 'spec_helper'
require_relative '../parse-apt-log'
include AptLogToHash


RSpec.describe "#find_in_commands method" do
  let(:log_file_loc) { 'spec/sample/history.log' }
  let(:file_content)  { File.open(log_file_loc) { |f| f.read } }
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

RSpec.describe "#pretty_output method" do
  let(:section_hash) do {"Start-Date"=>"2016-12-19  21:14:55",
    "Commandline"=>"apt install nautilus-share pantheon",
    "Requested-By"=>"anwar (1000)",
    "Install"=>"nautilus-share:amd64 (0.7.3-2ubuntu1)",
    "End-Date"=>"2016-12-19  21:15:17"}
  end

  it "takes a hash as an argument" do
    expect { pretty_output }.to raise_error(ArgumentError, /0 for 1/)
    expect { pretty_output([]) }.to raise_error(ArgumentError, /Invalid argument:/)
    expect { pretty_output('') }.to raise_error(ArgumentError, /Invalid argument:/)
  end

  it "takes a hash containing 'Commandline' key" do
    expect { pretty_output({}) }.to raise_error(ArgumentError, /Not an apt-section hash/)
    expect { pretty_output(section_hash) }.not_to raise_error
  end
end

RSpec.describe "#scan_package_names" do
  let(:input_string) { "libdevmapper-dev:amd64 (2:1.02.110-1ubuntu10, automatic), libselinux1-dev:amd64 (2.4-3build2, automatic)" }
  let(:purge_line) { "linux-headers-4.9.0-040900:amd64 (4.9.0-040900.201612111631), linux-headers-4.9.0-040900-generic:amd64 (4.9.0-040900.201612111631)" }
  let(:reinstall_line) { "seahorse:amd64 (3.18.0-2ubuntu1), gnome-online-accounts:amd64 (3.18.3-1ubuntu2)" }

  it "takes a string as input" do
    expect { scan_package_names }.to raise_error(ArgumentError, /0 for 1/)
  end

  it "returns the package names in a string separated by space" do
    expect(scan_package_names(input_string)).to eq "libdevmapper-dev:amd64 libselinux1-dev:amd64"
    expect(scan_package_names("california:amd64 (0.4.0-0ubuntu5)")).to eq "california:amd64"
    expect(scan_package_names(purge_line)).to eq "linux-headers-4.9.0-040900:amd64 linux-headers-4.9.0-040900-generic:amd64"
    expect(scan_package_names(reinstall_line)).to eq "seahorse:amd64 gnome-online-accounts:amd64"
  end
end

RSpec.describe "#read_apt_logs" do
  it "reads apt log files from /var/log/apt dir" do
    allow(self).to receive(:read_file)
    read_apt_logs
  end
end