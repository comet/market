class FixPaymentColumnType < ActiveRecord::Migration
  def self.up
    rename_column :payments, :type, :transaction_type
  end

  def self.down
  end
end
