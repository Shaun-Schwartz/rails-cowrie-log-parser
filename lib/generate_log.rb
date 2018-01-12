require 'net/http'
require 'open-uri'
require 'json'

FILE = './cowrie.json'
# FILE = '/home/shaun/cowrie/log/cowrie.json'
API_URL = 'http://freegeoip.net/json/' # API rate limited to 15, 000 requests an hour

def geolocation(ip_address)
  url = API_URL + ip_address.to_s
  response = open(url).read
  get_location_data = JSON.parse(response)
  # return get_location_data
end

# Save to and load from db
def parse_logs_db(file)
  f = File.open(file, 'r:ISO-8859-1:UTF-8')
  last_log_time = Log.count > 0 ? Log.last.time : '0' # 0 needed if db is empty
  count = 0
  f.each do |line|
    jsonline = JSON.parse(line.gsub("\u0000", ''))
    if (jsonline['eventid'].include? 'cowrie.login') && (jsonline['protocol'] = 'ssh') && (jsonline['timestamp'] > last_log_time)
      if Log.find_by ip_address:jsonline['src_ip']
        existingLog = Log.find_by ip_address:jsonline['src_ip']
        region = existingLog.region
        country = existingLog.country
      else
        # String interpolation to return region and country separately
        location = geolocation(jsonline['src_ip'])
        region = location['region_name']
        country = location['country_name']
      end
      Log.create(time: jsonline['timestamp'].gsub("\u0000", ''),
                status: jsonline['eventid'],
                protocol: jsonline['protocol'],
                ip_address: jsonline['src_ip'],
                message: jsonline['message'].gsub("\u0000", ''),
                username: jsonline['username'].gsub("\u0000", ''),
                password: jsonline['password'].gsub("\u0000", ''),
                region: region,
                country: country)
    end
  end
end

parse_logs_db(FILE)
