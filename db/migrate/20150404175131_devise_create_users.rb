class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      t.string :firstname
      t.string :lastname
      t.string :phonenumber
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.string :zipcode
      t.string :publishable_key
      t.string :provider
      t.string :uid
      t.string :access_code
      t.datetime :birthday
      t.boolean :is_female, default: false
      t.integer :activejobs, default: 0
      t.integer :completedjobs, default: 0
      t.integer :totalcollected, default: 0
      t.boolean :completedbasictraining, default: false
      t.boolean :completedamazontraining, default: false
      t.boolean :completedtaskrabbittraining, default: false
      t.boolean :completedinstacarttraining, default: false
      t.text :description
      t.text :question1
      t.text :question2
      t.text :question3
      t.text :question4
      t.text :question5
      t.integer :numberofquestsflagged, default: 0
      t.integer :numberofreviews, default: 0
      t.integer :reviewpercentage, default: 100
      t.string :businessname
      t.integer :numberofnotes, default: 0

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at


      t.timestamps
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end
