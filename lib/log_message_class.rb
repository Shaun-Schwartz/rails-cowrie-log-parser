class LogMessage
  attr_accessor :time, :ip_address, :message, :location

  def initialize(time, ip_address, message, location = nil)
    @time = time
    @ip_address = ip_address
    @message = message
    @location = location
  end

end
