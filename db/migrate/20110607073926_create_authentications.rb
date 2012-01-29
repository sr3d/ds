class CreateAuthentications < ActiveRecord::Migration
  def self.up
    create_table :authentications do |t|
      t.integer :user_id
      t.string :provider, :limit => 45
      t.string :uid, :limit => 64
      t.string :token
      t.string :secret
      t.timestamps
    end
    
    add_index :authentications, :user_id
    add_index :authentications, [:provider, :uid], :unique => true
    
  end

  def self.down
    drop_table :authentications
  end
end
