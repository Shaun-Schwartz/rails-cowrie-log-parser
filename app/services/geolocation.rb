require 'net/http'
require 'open-uri'
require 'json'
class Geolocation
  attr_accessor :ip_address

  def initialize(ip_address)
    @ip_address = ip_address
  end

  def from_ip
    api_key = ENV.fetch("IPSTACK_API_KEY")
    url = 'http://api.ipstack.com/' + ip_address.to_s + '?access_key=' + api_key + '&output=json&legacy=1'
    response = open(url).read
    JSON.parse(response)
  end
end
