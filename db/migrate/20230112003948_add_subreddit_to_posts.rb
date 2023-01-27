class AddSubredditToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :subreddit, :string
  end
end
