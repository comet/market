class CreateJobPayments < ActiveRecord::Migration
  def self.up
    create_table :job_payments do |t|
      t.integer :payment_id
      t.integer :listing_id
      t.string :user_id
      t.integer :deliverable_id

      t.timestamps
    end
  end

  def self.down
    drop_table :job_payments
  end
end
