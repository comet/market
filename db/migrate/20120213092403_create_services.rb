class CreateServices < ActiveRecord::Migration
  def self.up
    create_table :services do |t|
      t.string :author_id
      t.string :title
      t.text :content
      t.string :status
      t.datetime :last_modified
      t.datetime :valid_until
      t.string :receiver_id
      t.string :category_id
      t.string :file_url

      t.timestamps
    end
  end

  def self.down
    drop_table :services
  end
end
