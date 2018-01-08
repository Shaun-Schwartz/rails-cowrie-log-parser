class ParseLogsController < ApplicationController
  require 'net/http'
  require 'open-uri'
  require 'json'

  FILE = './cowrie.json'
  FILE = '/home/shaun/cowrie/logs/cowrie.json'
  TIME_REGEX = /(?<=\().*(?=\))/ # matches everything between brackets
  IP_REGEX = /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/
  API_URL = 'http://freegeoip.net/json/'

  def geolocation(ip_address)
    url = API_URL + ip_address.to_s
    # API rate limited to 10, 000 requests an hour
    response = open(url).read
    get_location_data = JSON.parse(response)
    return "#{get_location_data['region_name']}, #{get_location_data['country_name']}"
  end

  # Save to and load from db
  def parse_logs_db(file)
    f = File.open(file, 'r:ISO-8859-1:UTF-8')
    last_log_time = Log.count > 0 ? Log.last.time : '0' # 0 needed if db is empty
    count = 0
    f.each do |line|
      count += 1
      if count == 1000
        break
      else
        jsonline = JSON.parse(line..gsub("\u0000"))
        if jsonline['timestamp'] > last_log_time
          if (jsonline['eventid'].include? 'cowrie.login') && (jsonline['protocol'] = 'ssh')
            # String interpolation to return region and country separately
            location = geolocation(jsonline['src_ip'])
            region = location[0, location.index(',')]
            country = location[location.index(', ')+2.. -1]
            Log.create(time: jsonline['timestamp']
                      status: jsonline['eventid'],
                      protocol: jsonline['protocol'],
                      ip_address: jsonline['src_ip'],
                      message: jsonline['message'],
                      username: jsonline['username'],
                      password: jsonline['password'],
                      region: region,
                      country: country)
          end
        end
      end
    end
  end

  def index
    parse_logs_db(FILE)
    @logs = Log.all.order(time: :desc)
  end

  def hour
    parse_logs_db(FILE)
    @logs = Log.where(time: (Time.now - 1.hour)..Time.now).order(time: :desc)
  end

  def day
    parse_logs_db(FILE)
    @logs = Log.where(time: (Time.now - 24.hours)..Time.now).order(time: :desc)
  end

  def week
    parse_logs_db(FILE)
    @logs = Log.where(time: (Time.now - 7.days)..Time.now).order(time: :desc)
  end

end
