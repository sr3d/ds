class AddPhoneAndApiTokenToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :phone, :string, :after => :email
    add_column :users, :api_token, :string, :after => :phone
  end

  def self.down
    remove_column :users, :phone
    remove_column :users, :api_token
  end
end
