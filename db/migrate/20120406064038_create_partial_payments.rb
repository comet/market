class CreatePartialPayments < ActiveRecord::Migration
  def self.up
    create_table :partial_payments do |t|
      t.integer :payment_id
      t.float :balance

      t.timestamps
    end
  end

  def self.down
    drop_table :partial_payments
  end
end
