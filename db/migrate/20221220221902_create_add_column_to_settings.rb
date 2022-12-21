class AddColumnToSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :settings, :refresh, :boolean, default: false
  end
end
