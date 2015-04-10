class AddFloatsToQuests < ActiveRecord::Migration
  def change
    change_column :quests, :pricetosquire, :float, :default => 0
    change_column :quests, :totalprice, :float, :default => 0
    change_column :quests, :squirescut, :float, :default => 0
  end
end
