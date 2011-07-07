class CreateAttendants < ActiveRecord::Migration
  def self.up
    create_table :attendants do |t|
      t.integer :user_id
      t.integer :invite_id
      t.integer :event_id
      t.boolean :is_co_organizer
      t.timestamps
    end
    
    add_index :attendants, :event_id
    add_index :attendants, :user_id
    add_index :attendants, :invite_id
  end

  def self.down
    drop_table :attendants
  end
end
