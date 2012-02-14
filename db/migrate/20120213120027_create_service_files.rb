class CreateServiceFiles < ActiveRecord::Migration
  def self.up
    create_table :service_files do |t|
      t.string :service_id
      t.string :file_name
      t.string :file_content_type
      t.integer :file_size
      t.datetime :file_uploaded_at

      t.timestamps
    end
  end

  def self.down
    drop_table :service_files
  end
end
