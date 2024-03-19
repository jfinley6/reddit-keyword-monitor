Rails.application.config.after_initialize do
  def fetch_interval_from_database
    # Fetch the interval from the database
    scheduler_setting = SchedulerConfigurationsController.get_interval_or_create
    refresh_time = "#{scheduler_setting}s"
  end

  # Allow update during runtime
  Sidekiq::Scheduler.dynamic = true
  
  Sidekiq.schedule = {
    'check_posts' => {
      'class' => 'CheckPosts',
      'every' => fetch_interval_from_database
    }
  }
  
end