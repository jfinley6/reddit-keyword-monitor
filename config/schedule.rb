set :output, "log/cron_log.log"

set :environment, "development"

every 1.minute do
    runner "Post.check_reddit_posts"
end