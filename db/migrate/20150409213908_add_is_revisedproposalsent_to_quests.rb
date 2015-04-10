class AddIsRevisedproposalsentToQuests < ActiveRecord::Migration
  def change
    add_column :quests, :is_revisedproposalsent, :boolean, default: false
  end
end
