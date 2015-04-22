class AddCallSidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :callsid, :string
  end
end
