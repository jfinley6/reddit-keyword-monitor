require 'clockwork'
require 'active_support/time' # Allow numeric durations (eg: 1.minutes)
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    puts "Running!!"
  end

  #TODO: Stop initialzing this code once sidekiq is ready to go
  every(ENV["INTERVAL"].to_i.seconds, 'frequent.job') do
    if Setting.first.refresh == true
        RedditPosts.get_posts
        LogManager.keep_last_10_lines
    end
  end

end