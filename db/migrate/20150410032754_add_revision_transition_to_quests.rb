class AddRevisionTransitionToQuests < ActiveRecord::Migration
  def change
    add_column :quests, :is_revisiontransition, :boolean, default: false
  end
end
