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
  puts "Package change details:"
  puts "Installed: " + scan_package_names(section_hash["Install"]) if section_hash.key?("Install")
  puts "Upgraded: " + scan_package_names(section_hash["Upgrade"]) if section_hash.key?("Upgrade")
  puts "Reinstalled: " + scan_package_names(section_hash["Reinstall"]) if section_hash.key?("Reinstall")
  puts "Removed: " + scan_package_names(section_hash["Remove"]) if section_hash.key?("Remove")
  puts "Purged: " + scan_package_names(section_hash["Purge"]) if section_hash.key?("Purge")
end

def read_apt_logs
  read_file('/var/log/apt/history.log')
end

if $0 == __FILE__
  print "Enter the command or package name to search: "
  search_term = gets.chomp

  file_content = read_file('../history.log.1')
  content_hash = parse_into_hash(file_content)
  found_results = find_in_commands(content_hash, search_term)

  puts "Found #{found_results.size} results\n"
  found_results.each do |result|
    pretty_output(result)
    puts
  end
end
