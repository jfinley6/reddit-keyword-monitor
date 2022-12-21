class AddKeywordsToPost < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :keywords, :string
  end
end
