# Logic to check posts and return with matching criteria
class RedditPosts

  # Checks if there is an active internet connection.
  # Returns:
  #   - true if an internet connection is available, false otherwise.
  # Side Effects:
  #   - Attempts to open a connection to 'http://www.google.com/' using URI.open.
  #   - Rescues any exceptions that may occur during the connection attempt.
  def self.internet_connection?
    begin
      # Attempt to open a connection to 'http://www.google.com/' with a timeout of 5 seconds
      URI.open('http://www.google.com/', {read_timeout: 5})
      return true
    rescue SocketError, Errno::ECONNREFUSED, Net::OpenTimeout
      # Rescue specific exceptions that might occur due to connectivity issues
      return false
    end

    # Return false if no exception is raised but the connection fails
    false
  end

  # Fetches new posts from a specified subreddit on Reddit.
  #
  # Side Effects:
  #   - Logs a warning if there is no internet connection or if there is a timeout
  #     connecting to Reddit.
  #   - Filters and processes the fetched Reddit posts.
  def self.get_posts
    unless self.internet_connection?
      Rails.logger.warn "No Internet: #{Time.now.strftime('%I:%M:%S %p').sub(/^(0+:?)*/, '')}"
      return
    end

    begin
      # Fetch posts from the specified subreddit
      response = HTTParty.get("https://www.reddit.com/r/#{Setting.first.subreddit_name}/new.json?limit=25", timeout: 7)
      response_body = JSON.parse(response.body)
      filter_reddit_posts(response_body['data']['children'])
    rescue Net::OpenTimeout
      # Log a warning if there is a timeout connecting to Reddit
      Rails.logger.warn "Reddit Connection Timeout: #{Time.now.strftime('%I:%M:%S %p').sub(/^(0+:?)*/, '')}"
      return
    end
  end

  # This method iterates over a collection of Reddit posts, filters them based on keywords,
  # and performs actions such as saving the post and sending email notifications.
  #
  # Parameters:
  #   - posts: An array of Reddit posts in JSON format.
  #
  # Returns: None
  def self.filter_reddit_posts(posts)
    # Fetch keywords from the database and 
    keywords = Setting.first.keywords
    post_found = false

    # Iterate over each post
    posts.each do |post|
      # Skip the post if it already exists in the database
      next if Post.exists?(url: post['data']['permalink'])

      # Check if the post title contains any of the keywords
      if keywords.split(',').any? { |keyword| post["data"]["title"].downcase.include? keyword.downcase }
        # Save the post to the database
        save_post(post)

        # Send email notification for the new post
        send_email(post)

        post_found = true
      end
    end
      # Log status if no new posts match the keywords
      Rails.logger.warn "No New Posts: #{Time.now.strftime("%I:%M:%S %p").sub(/^(0+:?)*/, '')}" unless post_found
  end

  # Saves a Reddit post to the database.
  #
  # Parameters:
  #   - post: Hash containing information about the Reddit post.
  #     It should have the following keys:
  #      - 'data': Hash containing post data.
  #       - 'title': String, the title of the post.
  #       - 'permalink': String, the permalink of the post.
  #       - 'subreddit': String, the subreddit where the post was made.
  #       - 'author': String, the author of the post.
  #       - 'created_utc': Integer, the UTC timestamp of post creation.
  #
  # Returns:
  #   - The saved Post object.
  # 
  # Side Effects:
  #   - Creates a new Post record in the database.
  # 
  # Notes:
  #   - The 'keywords' field of the Post record is populated with the keywords
  #     retrieved from the application settings. These keywords are stored as a
  #     comma-separated string.
  def self.save_post(post)
    Post.create!(
      title: post['data']['title'],
      url: post['data']['permalink'],
      keywords: Setting.first.keywords.to_s,
      subreddit: post['data']['subreddit'],
      author: post['data']['author'],
      created_utc: post['data']['created_utc']
    )
  end

  # Sends an email notification about a new post.
  #
  # Parameters:
  #   - new_post: Hash containing information about the new post.
  #     It uses the following keys:
  #     - :title: String, the title of the post.
  #     - :url: String, the URL of the post.
  #
  # Side Effects:
  #   - Sends an email using the PostMailer with the title and URL of the new post.
  #   - Logs a message indicating that the email has been sent or that it failed.
  def self.send_email(new_post)
    begin
      PostMailer.post_found(new_post["data"]["title"], new_post["data"]["url"]).deliver!
    rescue => e
      Rails.logger.warn "Email Failed - #{e.message} #{Time.now.strftime('%I:%M:%S %p').sub(/^(0+:?)*/, '')}"
    else
      Rails.logger.warn "Email Sent: #{Time.now.strftime('%I:%M:%S %p').sub(/^(0+:?)*/, '')}"
    end
  end

end
