class ParseLogsController < ApplicationController
  require 'generate_log.rb'
  before_action :check_jobs

  def index
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

  def check_jobs
    if Delayed::Job.count == 0
      ParseLogsJob.set(wait: 5.minutes).perform_later
    end
  end

end
