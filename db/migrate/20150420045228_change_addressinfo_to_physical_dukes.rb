class ChangeAddressinfoToPhysicalDukes < ActiveRecord::Migration
  def change
    rename_column :dukes, :city, :physicalcity
    rename_column :dukes, :state, :physicalstate
    rename_column :dukes, :zipcode, :physicalzipcode
    rename_column :dukes, :country, :physicalcountry
    add_column :dukes, :mailingcity, :string
    add_column :dukes, :mailingstate, :string
    add_column :dukes, :mailingzipcode, :string
    add_column :dukes, :mailingcountry, :string
  end
end
