class AddSquireidToDukes < ActiveRecord::Migration
  def change
    add_column :dukes, :squire_id, :integer
  end
end
