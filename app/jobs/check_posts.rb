require 'sidekiq-scheduler'

# Services related to getting posts from Reddit
class CheckPosts
  include Sidekiq::Worker

  def perform
    RedditPosts.get_posts
  end
end
