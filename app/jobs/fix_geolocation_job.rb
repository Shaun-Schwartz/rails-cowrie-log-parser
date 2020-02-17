class FixGeolocationJob
  include Sidekiq::Worker

  def perform
    Log.where(country: nil).each do |log|
      GeolocationJob.perform_async(log.ip_address, log.id)
    end
  end
end
