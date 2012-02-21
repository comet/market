class FixPaymentAmountTypeToDecimal < ActiveRecord::Migration
  def self.up
    change_table :payments do |t|
      t.change :amount, :float
      t.change :post_balance, :float
  end
 end

  def self.down
  end
end
