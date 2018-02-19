class ParseLogsController < ApplicationController
  # Make sure a job is queued
  before_action :check_jobs

  def index
    @last_5_minutes = Log.where(time: (Time.now - 5.minutes)..Time.now).count
    @last_hour = Log.where(time: (Time.now - 1.hour)..Time.now).count
    @last_day = Log.where(time: (Time.now - 24.hour)..Time.now).count
    # Most seen IP addresses by all time, hour, 24 hours, and week
    @top_ips = Log.find_by_sql("SELECT COUNT(*), ip_address, region, country
                                FROM logs GROUP BY(ip_address, region, country)
                                ORDER BY COUNT(ip_address) DESC LIMIT 10;")
    @top_ips_hour = Log.find_by_sql("SELECT COUNT(*), ip_address, region, country
                                FROM logs WHERE(time > ( NOW()-INTERVAL '1 hour')) GROUP BY(ip_address, region, country)
                                ORDER BY COUNT(ip_address) DESC LIMIT 10;")
    @top_ips_24hours = Log.find_by_sql("SELECT COUNT(*), ip_address, region, country
                                FROM logs WHERE(time > ( NOW()-INTERVAL '24 hours')) GROUP BY(ip_address, region, country)
                                ORDER BY COUNT(ip_address) DESC LIMIT 10;")
    @top_ips_week = Log.find_by_sql("SELECT COUNT(*), ip_address, region, country
                                FROM logs WHERE(time > ( NOW()-INTERVAL '7 days')) GROUP BY(ip_address, region, country)
                                ORDER BY COUNT(ip_address) DESC LIMIT 10;")
  end

  def all
    @logs = Log.all.order(time: :desc).paginate(:page => params[:page], :per_page => 500)
  end

  def hour
    @logs = Log.where(time: (Time.now - 1.hour)..Time.now).order(time: :desc).paginate(:page => params[:page], :per_page => 500)
  end

  def day
    @logs = Log.where(time: (Time.now - 24.hours)..Time.now).order(time: :desc).paginate(:page => params[:page], :per_page => 500)
  end

  def week
    @logs = Log.where(time: (Time.now - 7.days)..Time.now).order(time: :desc).paginate(:page => params[:page], :per_page => 500)
  end

  def by
    @ip_address = params[:ip]
    @logs = Log.where(ip_address: @ip_address).order(time: :desc)
  end

  def pcap
    @ip_address = params[:ip_address]
    @log_id = params[:id]
    if user_signed_in?
      capture_name = "#{@ip_address}_#{DateTime.now}.pcap"
      system "tcpdump -nni en0 -G 600 host #{@ip_address} -w public/captures/#{capture_name} &"
      pcap = Capture.new(name: capture_name, log_id: @log_id)
      if pcap.save
        redirect_to by_path(ip: @ip_address), notice: "Capture started"
        p ("PCAP STARTED")
      else
        redirect_to by_path(ip: @ip_address), notice: "Capture could not be started"
      end
    else
      redirect_to by_path(ip: @ip_address), alert: "Must be signed in"
    end
  end

  def check_jobs
    # If there isn't a job queued, add one
    if Delayed::Job.count == 0
      ParseLogsJob.set(wait: 5.minutes).perform_later
    end
  end

end
