class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :title
      t.text :explanation
      t.integer :squire_id
      t.integer :duke_id
      t.integer :quest_id

      t.timestamps null: false
    end
  end
end
