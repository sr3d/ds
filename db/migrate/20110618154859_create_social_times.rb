class CreateSocialTimes < ActiveRecord::Migration
  def self.up
    create_table :social_times do |t|
      t.integer :user_id
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end

  def self.down
    drop_table :social_times
  end
end
