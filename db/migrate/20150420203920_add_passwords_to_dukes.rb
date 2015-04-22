class AddPasswordsToDukes < ActiveRecord::Migration
  def change
    add_column :dukes, :password, :string
    add_column :dukes, :password_confirmation, :string
  end
end
