class AddRsidAndTranscriptionToAudios < ActiveRecord::Migration
  def self.up
    add_column :audios, :recording_sid, :string
    add_column :audios, :transcription, :text
    
    add_index :audios, :recording_sid
  end

  def self.down
    remove_column :audios, :recording_sid
    remove_column :audios, :transcription
  end
end
