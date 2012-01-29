class CreateInvites < ActiveRecord::Migration
  def self.up
    create_table :invites do |t|
      t.integer :user_id
      t.string :email, :limit => 100
      t.string :name, :limit => 100
      t.string :token, :limit => 100
      t.timestamps
    end
    
    add_index :invites, [:email, :token]
    add_index :invites, :user_id
    
  end

  def self.down
    drop_table :invites
  end
end
