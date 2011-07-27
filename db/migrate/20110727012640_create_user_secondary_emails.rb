class CreateUserSecondaryEmails < ActiveRecord::Migration
  def self.up
    create_table :user_secondary_emails do |t|
      t.integer :user_id, :null => false
      t.string :email, :null => false
      t.timestamps
    end
    
    add_index :user_secondary_emails, :user_id
    add_index :user_secondary_emails, :email
  end

  def self.down
    drop_table :user_secondary_emails
  end
end
