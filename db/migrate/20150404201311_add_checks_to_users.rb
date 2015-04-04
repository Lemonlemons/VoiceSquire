class AddChecksToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stripecomplete, :boolean, default: false
    add_column :users, :trainingcomplete, :boolean, default: false
    add_column :users, :interviewcomplete, :boolean, default: false
    add_column :users, :registrationcomplete, :boolean, default: false

    def up
      change_column :users, :activequests, :integer, default: 0
      change_column :users, :completedquests, :integer, default: 0
    end

    def down
      change_column :users, :activejobs, :integer, default: 0
      change_column :users, :completedjobs, :integer, default: 0
    end
  end
end
