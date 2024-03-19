class JobScheduler
  def self.change_interval(new_interval)
    Sidekiq.set_schedule("check_posts", { "every" => "#{new_interval}s", "class" =>
                        "CheckPosts" })
  end
end