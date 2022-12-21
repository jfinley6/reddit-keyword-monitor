class AddLoadingToSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :settings, :loading, :boolean, default: false
  end
end
