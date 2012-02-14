class AddDetailsToListing < ActiveRecord::Migration
  def self.up
    add_column :listings, :subcategory, :string
    add_column :listings, :price, :decimal
  end

  def self.down
    remove_column :listings, :price
    remove_column :listings, :subcategory
  end
end
