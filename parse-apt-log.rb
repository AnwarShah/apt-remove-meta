require_relative 'lib/apt-log-to-hash'

include AptLogToHash

# This method finds a section containing a term
# in Commandline
def find_in_commands(content_hash_arr, search_term)
  return [] if search_term.empty?
  content_hash_arr.select do |hash|
    hash if hash["Commandline"].match(search_term)
  end
end

def read_apt_logs
  read_file('/var/log/apt/history.log')
end

if $0 == __FILE__
  file_content = read_file('history.log')
  content_hash = parse_into_hash(file_content)
  p find_in_commands(content_hash, 'ttf-mscorefonts-installer')
  p find_in_commands(content_hash, '')
end
