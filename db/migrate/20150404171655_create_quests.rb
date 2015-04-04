class CreateQuests < ActiveRecord::Migration
  def change
    create_table :quests do |t|
      t.integer :typeofquest
      t.string :audiolink
      t.text :textlink
      t.integer :squire_id
      t.integer :duke_id
      t.boolean :is_assigned, default: false
      t.boolean :is_proposalsent, default: false
      t.boolean :is_revisionrequested, default: false
      t.boolean :is_proposalaccepted, default: false
      t.boolean :is_proofsubmitted, default: false
      t.boolean :is_completed, default: false
      t.integer :timesflagged, default: 0
      t.string :title
      t.text :description
      t.integer :pricetosquire
      t.integer :totalprice
      t.integer :squirescut
      t.string :picture1
      t.string :picture2
      t.string :picture3

      t.timestamps null: false
    end
  end
end
