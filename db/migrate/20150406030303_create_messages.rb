class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :title
      t.text :body
      t.boolean :is_email, default: false
      t.boolean :is_text, default: false
      t.integer :squire_id
      t.integer :duke_id
      t.integer :quest_id

      t.timestamps null: false
    end
  end
end
