require 'ipstack_api_key'
include ApiKey
class ParseLogsJob < ApplicationJob
  queue_as :default
  require 'net/http'
  require 'open-uri'
  require 'json'

  def perform(*args)
    if File.exists?('/home/shaun/cowrie/log/cowrie.json')
      file = '/home/shaun/cowrie/log/cowrie.json' # "Production" logs
    else
      file = './cowrie.json' # Dev logs
    end
    f = File.open(file, 'r:ISO-8859-1:UTF-8')
    # Check log timestamp against last db entry time
    last_log_time = Log.count > 0 ? Log.last.time : '0' # 0 needed if db is empty
    f.each do |line|
      # Parse each line as json and remove characters that cause errors
      jsonline = JSON.parse(line.gsub('\u0000', ''))
      if (jsonline['eventid'].include? 'cowrie.login') && (jsonline['protocol'] = 'ssh') && (jsonline['timestamp'] > last_log_time)
        # If log exists grab geolocation data from it rather than making API call
        if Log.find_by ip_address:jsonline['src_ip']
          existingLog = Log.find_by ip_address:jsonline['src_ip']
          region = existingLog.region
          country = existingLog.country
        else
        # Call geolocation function to make API call for geo data
          location = geolocation(jsonline['src_ip'])
          region = location['region_name']
          country = location['country_name']
        end
        # Create db entry
        Log.create(time: jsonline['timestamp'].gsub('\u0000', ''),
                  status: jsonline['eventid'],
                  protocol: jsonline['protocol'],
                  ip_address: jsonline['src_ip'],
                  message: jsonline['message'].gsub('\u0000', ''),
                  username: jsonline['username'].gsub('\u0000', ''),
                  password: jsonline['password'].gsub('\u0000', ''),
                  region: region,
                  country: country,
                  session_id: jsonline['session'])
      # Call get_session_length function to get session length in seconds
      elsif jsonline['eventid'] = 'cowrie.session.closed'
        get_session_length(jsonline['session'], jsonline['duration'])
      end
    end
  end

  def geolocation(ip_address)
    api_key = ApiKey::ipstack_key
    url = 'http://api.ipstack.com/' + ip_address.to_s + '?access_key=' + api_key + '&output=json&legacy=1'
    response = open(url).read
    get_location_data = JSON.parse(response)
  end
  def get_session_length(session_id, session_length)
    # Find log by session_id, if found update session_length column for log
    corresponding_log = Log.find_by session_id: session_id || nil
    if corresponding_log&.present?
      corresponding_log.session_length = session_length
      corresponding_log.save
    end
  end
  ParseLogsJob.set(wait:5.minutes).perform_later
end
