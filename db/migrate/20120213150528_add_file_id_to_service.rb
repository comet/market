class AddFileIdToService < ActiveRecord::Migration
  def self.up
    add_column :services,:file_id, :integer
  end

  def self.down
    remove_column :services,:file_id
  end
end
