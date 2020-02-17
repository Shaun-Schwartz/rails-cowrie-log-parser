class GeolocationJob
  include Sidekiq::Worker

  def perform(ip_address, new_log_id)
    # If recent log exists grab geolocation data from it rather than making API call
    existing_log = Log.where(ip_address: ip_address)
                      .where.not(id: new_log_id)
                      .where.not(country: nil)
                      .where("created_at > ?", Time.now + 30.days)
                      .first
    new_log = Log.find(new_log_id)
    if existing_log&.country
      region = existing_log.region
      country = existing_log.country
    else
      location = Geolocation.new(ip_address).from_ip
      region = location['region_name']
      country = location['country_name']
    end
    new_log.update(region: region, country: country)
  end
end
