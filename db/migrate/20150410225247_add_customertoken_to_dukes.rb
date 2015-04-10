class AddCustomertokenToDukes < ActiveRecord::Migration
  def change
    add_column :dukes, :customertoken, :string
  end
end
