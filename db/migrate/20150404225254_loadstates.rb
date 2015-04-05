class Loadstates < ActiveRecord::Migration
  def self.up
    states = ['AL','AK','AZ','AR','CA','CO','CT','DE','FL','GA','HI','ID','IL',
      'IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV',
      'NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX',
      'UT','VT','VA','WA','WV','WI','WY']

    for state in states
        State.create(:name=>state)
    end
  end

  def self.down
    State.delete_all
  end
end
