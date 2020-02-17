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

  def self.parse_log_line(jsonline, time)
    (jsonline['eventid'].include? 'cowrie.login') &&
    (jsonline['protocol'] = 'ssh') &&
    (jsonline['timestamp'].to_datetime > time)
  end

  def line_include_ssh_login_attempt(line)
    (line['eventid'].include?('cowrie.login') && line['system'].include?('SSHService'))
  end
end
