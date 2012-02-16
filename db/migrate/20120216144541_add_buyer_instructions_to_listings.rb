class AddBuyerInstructionsToListings < ActiveRecord::Migration
  def self.up
    add_column :listings, :buyer_instruction, :string
  end

  def self.down
    remove_column :listings, :buyer_instruction
  end
end
