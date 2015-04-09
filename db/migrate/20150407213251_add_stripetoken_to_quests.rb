class AddStripetokenToQuests < ActiveRecord::Migration
  def change
    add_column :quests, :stripetoken, :string
  end
end
