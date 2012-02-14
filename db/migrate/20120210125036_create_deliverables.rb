class CreateDeliverables < ActiveRecord::Migration
  def self.up
    create_table :deliverables do |t|
      t.string :author_id
      t.string :title
      t.text :content
      t.boolean :status,          :default => false
      t.string :comment,        :default => "Not yet performed"
      t.boolean :satisfactory,  :default => false
      t.datetime :last_modified
      t.datetime :valid_until
      t.string :receiver_id
      t.string :category_id
      t.string :file_url

      t.timestamps
    end
  end

  def self.down
    drop_table :deliverables
  end
end
