class AddAudioIdToInterviews < ActiveRecord::Migration
  def self.up
    add_column :interviews, :audio_id, :integer
  end

  def self.down
    remove_column :interviews, :audio_id
  end
end
