class GeolocationJob
  include Sidekiq::Worker

  def perform(ip_address)
    # If recent log exists grab geolocation data from it rather than making API call
    existing_log = Log.where(ip_address: ip_address).where("created_at > ?", Time.now + 30.days).first
    if existing_log&.country
      region = existing_log&.region
      country = existing_log.country
    else
      location = Geolocation.new(ip_address).from_ip
      region = location['region_name']
      country = location['country_name']
    end
  end
end
