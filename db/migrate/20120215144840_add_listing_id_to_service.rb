class AddListingIdToService < ActiveRecord::Migration
  def self.up
    add_column :services, :listing_id, :integer
  end

  def self.down
    remove_column :services, :listing_id
  end
end
