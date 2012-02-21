class CreateMoneyAccounts < ActiveRecord::Migration
  def self.up
    create_table :money_accounts do |t|
      t.integer :type
      t.string :name
      t.string :identifier

      t.timestamps
    end
  end

  def self.down
    drop_table :money_accounts
  end
end
