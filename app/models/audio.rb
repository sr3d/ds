class Audio < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user_id, :url, :description, :duration, :recording_sid, :transcription
  
  def has_transcription?
    !transcription.nil?
  end
end
