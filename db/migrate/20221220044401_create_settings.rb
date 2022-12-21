class CreateSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :settings do |t|
      t.string :subreddit_name, default: "Denver"
      t.string :keywords, default: "weather,apartment"

      t.timestamps
    end
  end
end
