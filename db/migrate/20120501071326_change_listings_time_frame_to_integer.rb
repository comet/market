class ChangeListingsTimeFrameToInteger < ActiveRecord::Migration
  def self.up
    change_column :listings, :time_frame, :integer
  end

  def self.down
    remove_column :listings, :time_frame
  end
end
