class AddSentbyToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :sentby_duke, :boolean, default: false
    add_column :messages, :sentby_squire, :boolean, default: false
  end
end
