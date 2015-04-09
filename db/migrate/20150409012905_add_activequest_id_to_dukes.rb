class AddActivequestIdToDukes < ActiveRecord::Migration
  def change
    add_column :dukes, :activequest_id, :integer
  end
end
