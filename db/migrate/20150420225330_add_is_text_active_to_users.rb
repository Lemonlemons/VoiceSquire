class AddIsTextActiveToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_text_active, :boolean, default: false
  end
end
