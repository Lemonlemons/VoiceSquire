class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.text :explanation
      t.integer :squire_id
      t.integer :duke_id
      t.integer :quest_id

      t.timestamps null: false
    end
  end
end
