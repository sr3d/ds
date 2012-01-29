class CreateVideo < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.integer   :interview_id
      t.text      :url
      t.text      :title
      t.text      :description
      t.text      :location
      t.text      :category
      t.timestamps
    end

    add_index :videos, :interview_id
  end

  def self.down
    drop_table :videos 
  end


end
