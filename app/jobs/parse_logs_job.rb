class ParseLogsJob
  include Sidekiq::Worker
  require 'net/http'
  require 'open-uri'
  require 'json'

  def perform(*args)
    file = ENV.fetch('LOG_FILE_PATH')
    return unless File.exists?(file)
    f = File.open(file, 'r:ISO-8859-1:UTF-8')
    # Check log timestamp against last db entry time
    last_log_time = Log.last&.time || 0 # 0 needed if db is empty
    f.each do |line|
      # Parse each line as json and remove characters that cause errors
      next unless line.include?('cowrie.command.success')
      jsonline = JSON.parse(line.gsub('\u0000', ''))
      next unless Log.parse_log_line(jsonline, last_log_time)
      Log.create_from_raw_json(jsonline)
      if jsonline['eventid'] = 'cowrie.session.closed'
        get_session_length(jsonline['session'], jsonline['duration'])
      end
      source_ip = jsonline['src_ip']
      GeolocationJob.perform_async(source_ip)
    end
  end

  def get_session_length(session_id, session_length)
    # Find log by session_id, if found update session_length column for log
    corresponding_log = Log.find_by(session_id: session_id)
    return unless corresponding_log.present?
    corresponding_log.update(session_length: session_length)
  end
end
