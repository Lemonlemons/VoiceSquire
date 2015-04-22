class AddIsActiveToDukes < ActiveRecord::Migration
  def change
    add_column :dukes, :is_active, :boolean, default: false
  end
end
