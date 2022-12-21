class AddRefreshTimeToSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :settings, :refresh_time, :string, default: "30"
  end
end
