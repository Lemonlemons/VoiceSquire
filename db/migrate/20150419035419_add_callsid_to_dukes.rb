class AddCallsidToDukes < ActiveRecord::Migration
  def change
    add_column :dukes, :callsid, :string
  end
end
