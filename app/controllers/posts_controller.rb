require 'pry'

class PostsController < ApplicationController

    def index
        get_messages
        get_posts
        @logs = `tail -n 10 log/development.log`
        @display_messages = IO.readlines('log/development.log').last(10).reverse
        @subreddit_name = Setting.first.subreddit_name

        if Setting.first.refresh == false
            @auto_title = "Start Checking Posts Automatically"
        else
            @auto_title = "Stop Checking Posts Automatically"
        end
    end

    def auto_check_posts
        if Setting.first.refresh == false
            system "whenever --update-crontab"
            Setting.first.update(refresh: true)
            refresh_page
        else
            system "crontab -r"
            Setting.first.update(refresh: false)
            refresh_page
        end
    end
    
    def edit_keywords_cookies 
        if params[:keywords].gsub(", ", ",") == Setting.first.keywords
            redirect_to root_path
            return
        end
        Setting.first.update(keywords: params[:keywords]) 
        logger.warn "Keyword".pluralize(params[:keywords].split(",").length) + " changed to " + params[:keywords].gsub(",", ", ") + " at " + Time.now.strftime("%H:%M:%S")
        redirect_to root_path
    end

    def edit_subreddit_cookies 
        if params[:subreddit_name] == Setting.first.subreddit_name
            redirect_to root_path
            return
        end
        Setting.first.update(subreddit_name: params[:subreddit_name])
        logger.warn "Subreddit name changed to " + params[:subreddit_name].to_s + " at " + Time.now.strftime("%H:%M:%S")
        
        get_messages
        render turbo_stream: [
            turbo_stream.replace(:subreddit,
                partial: "posts/subreddit",
                locals: { subreddit_name: Setting.first.subreddit_name }),
                turbo_stream.replace(:messages,
                    partial: "posts/messages",
                    locals: { display_messages: @messages, empty_log: @empty_log })     
        ]
    end

    def delete_all_posts
        if Post.all.count == 0
            logger.warn "No Posts To Delete at " + Time.now.strftime("%H:%M:%S")
        else
           logger.warn "All Posts Deleted at " + Time.now.strftime("%H:%M:%S") 
        end
        Post.destroy_all
        update_messages_and_posts
    end

    def delete_all_messages
        File.truncate('log/development.log', 0)
        update_messages_and_posts
    end

    def show
        Post.check_reddit_posts

        update_messages_and_posts
    end

    def delete_post
        post = Post.find(params[:post_id])
        post.update(deleted: true)

        update_messages_and_posts
    end
    
    private

    def refresh_page
        respond_to do |format|
                format.js {
                    render "posts/refresh"
                }
        end
    end

    def get_posts
        @posts = Post.where("deleted = false").limit(10).order("id DESC")

        if @posts.count < 10
            @empty_posts = 10 - @posts.count
        else
            @empty_posts = 0
        end
    end
    
    def get_messages
        @messages = IO.readlines('log/development.log').last(10).reverse
        if @messages.count < 10
            @empty_log = 10 - @messages.count
        else
            @empty_log = 0
        end
    end

    def update_messages_and_posts
        get_messages
        get_posts
        render turbo_stream: [
            turbo_stream.replace(:messages,
                partial: "posts/messages",
                locals: { display_messages: @messages, empty_log: @empty_log }),
                turbo_stream.replace(:posts,
                partial: "posts/posts",
                locals: { posts: @posts, empty_posts: @empty_posts })
        ]
    end

end
