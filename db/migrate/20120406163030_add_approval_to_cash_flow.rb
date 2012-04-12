class AddApprovalToCashFlow < ActiveRecord::Migration
  def self.up
    add_column :cashflows, :approved, :integer
  end

  def self.down
    remove_column :cashflows, :approved
  end
end
