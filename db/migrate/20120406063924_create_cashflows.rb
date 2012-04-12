class CreateCashflows < ActiveRecord::Migration
  def self.up
    create_table :cashflows do |t|
      t.string :user_id
      t.float :amount
      t.string :sender_user_id
      t.integer :listing_id

      t.timestamps
    end
  end

  def self.down
    drop_table :cashflows
  end
end
