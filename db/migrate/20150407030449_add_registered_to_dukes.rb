class AddRegisteredToDukes < ActiveRecord::Migration
  def change
    add_column :dukes, :registered, :boolean, default: false
  end
end
