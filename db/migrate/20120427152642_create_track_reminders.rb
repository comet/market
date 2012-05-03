class CreateTrackReminders < ActiveRecord::Migration
  def self.up
    create_table :track_reminders do |t|
      t.integer :service_id
      t.integer :job_id

      t.timestamps
    end
  end

  def self.down
    drop_table :track_reminders
  end
end
