class AddProofToQuests < ActiveRecord::Migration
  def change
    add_column :quests, :proof1, :string
    add_column :quests, :proof2, :string
    add_column :quests, :proof3, :string
  end
end
