class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :account_id
      t.integer :super_type
      t.integer :type
      t.string :receipt
      t.datetime :time
      t.string :phonenumber
      t.string :name
      t.string :account
      t.integer :status
      t.integer :amount
      t.integer :post_balance
      t.string :note
      t.integer :transaction_cost

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
