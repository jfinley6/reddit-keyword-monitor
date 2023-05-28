require 'clockwork'
require 'active_support/time' # Allow numeric durations (eg: 1.minutes)
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    puts "Running!!"
  end

  every(10.seconds, 'frequent.job') do
    if Setting.first.refresh == true
        Post.check_reddit_posts
    end
  end

end