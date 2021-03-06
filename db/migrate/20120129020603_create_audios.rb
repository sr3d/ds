class CreateAudios < ActiveRecord::Migration
  def self.up
    create_table :audios do |t|
      t.integer :user_id
      t.string :url
      t.text :description
      t.integer :duration, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :audios
  end
end
