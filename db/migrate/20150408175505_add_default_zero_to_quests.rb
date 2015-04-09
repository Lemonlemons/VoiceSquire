class AddDefaultZeroToQuests < ActiveRecord::Migration
  def change
    change_column :quests, :pricetosquire, :integer, :default => 0
    change_column :quests, :totalprice, :integer, :default => 0
    change_column :quests, :squirescut, :integer, :default => 0
  end
end
