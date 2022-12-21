Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "posts#index"
  get "/check_posts", to: "posts#show" 
  get "/edit_keywords_cookies", to: "posts#edit_keywords_cookies"
  get "/edit_subreddit_cookies", to: "posts#edit_subreddit_cookies"
  get "/delete_all_posts", to: "posts#delete_all_posts"
  get "/delete_all_logs", to: "posts#delete_all_logs"
  get "/auto_check", to: "posts#auto_check_posts"
end
