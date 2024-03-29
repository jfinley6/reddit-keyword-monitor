class Post < ApplicationRecord
    validates :keywords, presence: true
    
    def self.check_reddit_posts

        if internet_connection?

            begin
                response = HTTParty.get("https://www.reddit.com/r/#{Setting.first.subreddit_name}/new.json?limit=25", timeout: 7)
                response_body = JSON.parse(response.body)
                posts = response_body["data"]["children"]
            rescue Net::OpenTimeout
                logger.warn "Reddit Connection Timeout: " + Time.now.strftime("%I:%M:%S %p").sub(/^(0+:?)*/, '')
                return
            end

            posts.each {|post| 
                if Setting.first.keywords.split(",").any? { |string| post["data"]["title"].downcase.include? string.downcase }
                    if Post.exists?(url: post["data"]["permalink"])
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
                        logger.warn "Email Sent: " + Time.now.strftime("%I:%M:%S %p").sub(/^(0+:?)*/, '')
                        return
                    end
                end
            }
            logger.warn "No New Posts: " + Time.now.strftime("%I:%M:%S %p").sub(/^(0+:?)*/, '')
            return
        else
            logger.warn "No Internet: " + Time.now.strftime("%I:%M:%S %p").sub(/^(0+:?)*/, '')
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

