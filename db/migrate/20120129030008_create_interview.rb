class CreateInterview < ActiveRecord::Migration
  def self.up
    create_table :interviews do |t|
      t.integer   :user_id, :null => false
      t.integer   :type_id
      t.text      :url
      t.text      :title
      t.text      :description
      t.text      :location
      t.text      :category
      t.timestamps
    end
    
    add_index :events, :user_id
  end

  def self.down
  end
end
