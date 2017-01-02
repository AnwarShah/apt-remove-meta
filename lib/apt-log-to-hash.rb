require 'zlib'

module AptLogToHash
  def read_file(filename)
    begin
      unless File.exist?(filename)
        raise ArgumentError.new("Invalid filename")
      end
    end

    # If log file is a gzip file, read using appropriate one
    if is_gzip_file?(filename)
      return read_gzip_file(filename)
    else
      # Read the file first
      file_content = nil; # contents of the file will be stored here
      File.open(filename) do |f|
        file_content = f.read
      end
    end
  end

  # This method takes the raw apt-history file content
  # and store into an array of hashes
  def parse_into_hash(file_content)
    # apt-history file is seperated by double new line
    file_sections = file_content.split("\n\n")

    # split the sections by line within them
    file_sections.map! { |section| section.split("\n") }

    # split each line of the sections by : seperator
    file_sections.map! do |section|
      section.map! do |line|
        line.partition(": ").values_at(0, 2) # we don't need the seperator
      end
      section.to_h # Now make a hash of key-value pairs from 2-D array
    end
  end

  ## This method takes a filename as argument and return
  # whether that file is a gzip file
  # It currently only checks the extension
  def is_gzip_file?(filepath)
    # IO.popen(["file", "--brief", "--mime-type", path], &:read).chomp
    extension = File.extname(filepath)
    extension == ".gzip" || extension == ".gz"
  end

  private
  ## This method reads a gz file and returns it's content
  def read_gzip_file(filename)
    content = ""
    File.open(filename) do |f|
      gz = Zlib::GzipReader.new(f)
      content += gz.read
      gz.close
    end
    content
  end
end