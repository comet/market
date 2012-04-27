class AddOverdueToServices < ActiveRecord::Migration
  def self.up
    add_column :services, :overdue, :integer,:default=>0
    add_column :services, :extra_time, :integer,:default=>0
  end

  def self.down
    remove_column :services, :extra_time
    remove_column :services, :overdue
  end
end
