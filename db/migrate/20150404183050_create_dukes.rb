class CreateDukes < ActiveRecord::Migration
  def change
    create_table :dukes do |t|
      t.string :phonenumber
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :mailingaddress
      t.string :city
      t.string :state
      t.string :country
      t.string :zipcode
      t.integer :preferredproposalmethod
      t.datetime :birthday
      t.boolean :is_landline, default: false
      t.boolean :is_mailingsameasphysicaladdress, default: true
      t.string :physicaladdress
      t.boolean :is_female, default: false
      t.integer :rating, default: 100
      t.integer :numberofquests, default: 0
      t.integer :numberofnotes, default: 0

      t.timestamps null: false
    end
  end
end
