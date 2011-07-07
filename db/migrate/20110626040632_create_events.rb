class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer   :user_id, :null => false
      t.integer   :event_type_id
      t.string    :name
      t.text      :description
      t.datetime  :when
      t.datetime  :start_time
      t.datetime  :end_time
      t.text :note

      t.timestamps
    end
    
    add_index :events, :user_id
    
  end

  def self.down
    drop_table :events
  end
end
