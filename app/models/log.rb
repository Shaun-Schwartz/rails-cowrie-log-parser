class Log < ApplicationRecord
  has_many :captures, dependent: :destroy

  def self.create_from_raw_json(rawjson)
    Log.create(time: rawjson['timestamp'].to_s.gsub('\u0000', ''),
              status: rawjson['eventid'],
              protocol: rawjson['protocol'],
              ip_address: rawjson['src_ip'],
              message: rawjson['message'].to_s.gsub('\u0000', ''),
              username: rawjson['username'].to_s.gsub('\u0000', ''),
              password: rawjson['password'].to_s.gsub('\u0000', ''),
              session_id: rawjson['session'])
  end

  def self.parse_log_line(line, time)
    ((line['eventid'].include? 'cowrie.login') &&
                (line['protocol'] = 'ssh') &&
                (line['timestamp'] > time)) ||
                line['eventid'] = 'cowrie.session.closed'
  end
end
