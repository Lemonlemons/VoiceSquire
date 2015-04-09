class AddRevisionToQuests < ActiveRecord::Migration
  def change
    add_column :quests, :revision, :text
  end
end
