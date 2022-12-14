class Post < ApplicationRecord
    
    def self.check_reddit_posts
        if internet_connection?

            response_code = 429
            while response_code != 200
                response = HTTParty.get("https://www.reddit.com/r/#{ENV["SUBREDDIT_NAME"]}/new.json")
                response_code = response.code
            end

            response_body = JSON.parse(response.body)
            posts = response_body["data"]["children"]

            posts.each {|post| 
                if ENV["MATCHING_WORDS"].split(",").any? { |string| post["data"]["title"].include? string }
                    if Post.exists?(title: post["data"]["title"])
                        next
                    else
                        new_post= Post.create(:title => post["data"]["title"], :url => post["data"]["permalink"])
                        PostMailer.post_found(new_post[:title], new_post[:url]).deliver!
                        logger.info "Email sent at " + Time.now.strftime("%H:%M:%S")
                    end
                end
            }
            logger.info "Done checking posts at " + Time.now.strftime("%H:%M:%S")
            return
        else
            logger.info "No internet"
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

