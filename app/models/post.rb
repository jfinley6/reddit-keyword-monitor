class Post < ApplicationRecord
    validates :keywords, presence: true
    
    def self.check_reddit_posts

        if internet_connection?
            
            response_code = 429
            while response_code != 200
                response = HTTParty.get("https://www.reddit.com/r/#{Setting.first.subreddit_name}/new.json")
                response_code = response.code
            end
            
            response_body = JSON.parse(response.body)
            posts = response_body["data"]["children"]

            posts.each {|post| 
                if Setting.first.keywords.split(",").any? { |string| post["data"]["title"].downcase.include? string.downcase }
                    if Post.exists?(title: post["data"]["title"])
                        next
                    else
                        new_post = Post.create!(:title => post["data"]["title"], :url => post["data"]["permalink"], :keywords => Setting.first.keywords.to_s)
                        PostMailer.post_found(new_post[:title], new_post[:url]).deliver!
                        logger.warn "Email Sent At " + Time.now.strftime("%I:%M%p").gsub("AM", "am").gsub("PM", "pm")
                    end
                end
            }
            logger.warn "Done Checking Posts At " + Time.now.strftime("%I:%M%p").gsub("AM", "am").gsub("PM", "pm")
            return
        else
            logger.warn "No Internet At " + Time.now.strftime("%I:%M%p").gsub("AM", "am").gsub("PM", "pm")
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

