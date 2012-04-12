class ChangeRatingValueToFloat < ActiveRecord::Migration
  def self.up
    change_column :ratings,:value,:float
  end

  def self.down
    remove_column :ratings, :value
  end
end
