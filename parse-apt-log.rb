require_relative 'lib/apt-log-to-hash'

include AptLogToHash

# This method finds a section containing a term
# in Commandline
def find_in_commands(content_hash_arr, search_term)
  return [] if search_term.empty?
  content_hash_arr.select do |hash|
    hash if hash["Commandline"].match(search_term) if hash["Commandline"]
  end
end

# This method takes a string from apt-log and returns only the package names from it
def scan_package_names(str_with_package_names)
  str_with_package_names.split('), '). # first split the individual pkages
    map { |part| part.partition(' ')[0] }. # then for each splitted part, pick the first item i.e name
    join(' ') # then join the array items with space
end

# This method takes a section hash and outputs with usabled format
def pretty_output(section_hash)
  raise ArgumentError.new('Invalid argument: Need a hash') unless section_hash.class == Hash
  raise ArgumentError.new('Invalid argument: Not an apt-section hash') unless section_hash.key?("Commandline")
  puts "Full command: " + section_hash["Commandline"]
  puts "User: " + section_hash["Requested-By"]
  puts "Date: " + section_hash["Start-Date"]
  puts "Package change details:"
  puts "Installed: " + scan_package_names(section_hash["Install"]) if section_hash.key?("Install")
  puts "Upgraded: " + scan_package_names(section_hash["Upgrade"]) if section_hash.key?("Upgrade")
  puts "Reinstalled: " + scan_package_names(section_hash["Reinstall"]) if section_hash.key?("Reinstall")
  puts "Removed: " + scan_package_names(section_hash["Remove"]) if section_hash.key?("Remove")
  puts "Purged: " + scan_package_names(section_hash["Purge"]) if section_hash.key?("Purge")
end

def read_apt_log_dir(dir = '/var/log/apt/')
  log_file_regex = dir + 'history.log*'
  log_files = Dir.glob(log_file_regex)
  content = '' # the content of all log files
  log_files.each do |log_file|
    content += read_file(log_file)
  end
  content
end

if $0 == __FILE__
  log_contents = read_apt_log_dir
  print "Enter a command or package name to search log: "
  search_term = gets.chomp

  content_hash = parse_into_hash(log_contents)
  found_results = find_in_commands(content_hash, search_term)

  puts "Found #{found_results.size} results\n"
  found_results.each do |result|
    pretty_output(result)
    puts
  end
end
