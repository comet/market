class AddTimeToListing < ActiveRecord::Migration
  def self.up
    add_column :listings, :time_frame, :datetime
  end

  def self.down
    remove_column :listings, :time_frame
  end
end
