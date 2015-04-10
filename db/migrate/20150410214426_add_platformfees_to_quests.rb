class AddPlatformfeesToQuests < ActiveRecord::Migration
  def change
    add_column :quests, :platformfees, :float, default: 0
  end
end
