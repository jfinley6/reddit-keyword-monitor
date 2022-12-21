require 'pry'

class PostsController < ApplicationController

    def index
        # Setting.first.update(loading: false)
        @messages = IO.readlines('log/development.log')
        @logs = `tail -n 10 log/development.log`
        @display_messages = @messages.last(10).reverse
        @posts = Post.all.limit(10).order("id DESC")

        if @posts.count < 10
            @empty_posts = 10 - @posts.count
        else
            @empty_posts = 0
        end
        if @display_messages.count < 10
            @empty_log = 10 - @display_messages.count
        else
            @empty_log = 0
        end

        if Setting.first.refresh == false
            @auto_title = "Start Checking Posts Automatically"
        else
            @auto_title = "Stop Checking Posts Automatically"
        end
    end

    def show
        # Setting.first.update(loading: true)
        Post.check_reddit_posts
        redirect_to root_path
    end

    def auto_check_posts
        if Setting.first.refresh == false
            system "whenever --update-crontab"
            Setting.first.update(refresh: true)
            redirect_to root_path
        else
            system "crontab -r"
            Setting.first.update(refresh: false)
            redirect_to root_path
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
        redirect_to root_path
    end

    def delete_all_posts
        if Post.all.count == 0
            redirect_to root_path
            return
        end
        Post.destroy_all
        logger.warn "All Posts Deleted at " + Time.now.strftime("%H:%M:%S")
        redirect_to root_path
    end

    def delete_all_logs
        File.truncate('log/development.log', 0)
        redirect_to root_path
    end

end
