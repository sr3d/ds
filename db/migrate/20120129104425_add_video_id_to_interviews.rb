class AddVideoIdToInterviews < ActiveRecord::Migration
  def self.up
    add_column :interviews, :video_id, :integer
  end

  def self.down
    remove_column :interviews, :video_id
  end
end
