# Handles scheduling of Sidekiq jobs.
class JobScheduler
  # Changes the interval of a Sidekiq job.
  #
  # Parameters:
  #   - new_interval: Integer, the new interval in seconds for scheduling the job.
  #
  # Side Effects:
  #   - Updates the schedule for the Sidekiq job named "check_posts" to the new interval.
  #
  # Returns: None.
  def self.change_interval(new_interval)
    # Set the new schedule for the Sidekiq job
    Sidekiq.set_schedule("check_posts", { "every" => "#{new_interval}s", "class" => "CheckPosts" })
  end
end