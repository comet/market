class AddTextToRating < ActiveRecord::Migration
  def self.up
    add_column :ratings, :text, :string
  end

  def self.down
    remove_column :ratings, :text
  end
end
