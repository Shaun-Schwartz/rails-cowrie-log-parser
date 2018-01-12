class ParseLogsController < ApplicationController
  require 'generate_log.rb'

  def index
    # parse_logs_db(FILE)
    @logs = Log.all.order(time: :desc).paginate(:page => params[:page], :per_page => 500)
  end

  def hour
    # parse_logs_db(FILE)
    @logs = Log.where(time: (Time.now - 1.hour)..Time.now).order(time: :desc).paginate(:page => params[:page], :per_page => 500)
  end

  def day
    # parse_logs_db(FILE)
    @logs = Log.where(time: (Time.now - 24.hours)..Time.now).order(time: :desc).paginate(:page => params[:page], :per_page => 500)
  end

  def week
    # parse_logs_db(FILE)
    @logs = Log.where(time: (Time.now - 7.days)..Time.now).order(time: :desc).paginate(:page => params[:page], :per_page => 500)
  end

end
