Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root "posts#index"
  get "/check_posts", to: "posts#check_posts" 
  get "/edit_keywords_cookies", to: "posts#edit_keywords_cookies"
  get "/edit_subreddit_cookies", to: "posts#edit_subreddit_cookies"
  get "/delete_all_posts", to: "posts#delete_all_posts"
  get "/delete_all_messages", to: "posts#delete_all_messages"
  get "/auto_check", to: "posts#auto_check_posts"
  get "/delete_post/:post_id", to: "posts#delete_post"
  get "/messages", to: "posts#messages"
  get "/posts", to: "posts#posts"
  resources :posts
end
