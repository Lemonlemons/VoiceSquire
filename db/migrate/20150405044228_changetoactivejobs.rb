class Changetoactivejobs < ActiveRecord::Migration
  def change
    rename_column :users, :activejobs, :activequests
    rename_column :users, :completedjobs, :completedquests
  end
end
