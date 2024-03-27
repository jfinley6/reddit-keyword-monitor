Rails.application.config.after_initialize do
  def fetch_interval_from_database
    # Fetch the interval from the database
    scheduler_setting = SchedulerConfigurationsController.get_interval_or_create
    refresh_time = "#{scheduler_setting}s"
  end

  # Allow update during runtime
  Sidekiq::Scheduler.dynamic = true

  # Check if posts are set to be checked automatically
  if Setting.first.refresh === true
  
    Sidekiq.schedule = {
      'check_posts_job' => {
        'class' => 'CheckPostsJob',
        'every' => fetch_interval_from_database
      },
      'keep_last_10_lines_job' => {
        'class' => 'KeepLast10LinesJob',
        'every' => fetch_interval_from_database
      }
    }

  end
  
end