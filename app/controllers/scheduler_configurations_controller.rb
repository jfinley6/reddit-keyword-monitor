class SchedulerConfigurationsController < ApplicationController
  def self.update_interval
    new_interval = params[:interval]
    JobScheduler.change_interval(new_interval)
  end

  def self.get_interval_or_create
    interval = Setting.first.refresh_time
    return interval || "30" 
  end

end