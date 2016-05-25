class OverWhat < ActiveRecord::Migration
  def change
    add_column :quests, :received_from, :integer
  end
end
