class Post < ApplicationRecord
    validates :keywords, presence: true
    
    def self.check_reddit_posts

        if internet_connection?
            
            reddit = Snoo::Client.new
            response = reddit.get_listing(subreddit: Setting.first.subreddit_name, page: "new", sort: "new", limit: 25)
            response_body = JSON.parse(response.body)
            posts = response_body["data"]["children"]
            reddit = nil

            posts.each {|post| 
                if Setting.first.keywords.split(",").any? { |string| post["data"]["title"].downcase.include? string.downcase }
                    if Post.exists?(title: post["data"]["title"])
                        next
                    else
                        new_post = Post.create!(
                            :title => post["data"]["title"], 
                            :url => post["data"]["permalink"], 
                            :keywords => Setting.first.keywords.to_s, 
                            :subreddit => post["data"]["subreddit"], 
                            :author => post["data"]["author"], 
                            :created_utc => post["data"]["created_utc"]
                        )
                        PostMailer.post_found(new_post[:title], new_post[:url]).deliver!
                        logger.warn "Email Sent At " + Time.now.strftime("%I:%M:%S %p").sub(/^(0+:?)*/, '')
                    end
                end
            }
            logger.warn "Done Checking Posts At " + Time.now.strftime("%I:%M:%S %p").sub(/^(0+:?)*/, '')
            return
        else
            logger.warn "No Internet At " + Time.now.strftime("%I:%M:%S %p").sub(/^(0+:?)*/, '')
            return
        end
    end

    def self.internet_connection?
        begin
            true if URI.open("http://www.google.com/")
        rescue
            false
        end
    end

end

