class AddDefaultZeroToActivequestsInQuests < ActiveRecord::Migration
  def change
    change_column :users, :activequests, :integer, :default => 0
  end
end
