class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :user_id
      t.integer :event_id
      t.text :comment

      t.timestamps
    end
    
    add_index :comments, :user_id
    add_index :comments, :event_id
    
  end

  def self.down
    drop_table :comments
  end
end
