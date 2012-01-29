class Interview < ActiveRecord::Base
  belongs_to :user  
  belongs_to :audio
  belongs_to :video
  # belongs_to :photos
  # belongs_to :text
    
  def audio?
    !audio_id.nil?
  end
  
  def video?
    !video_id.nil?
  end
  
  def duration
    audio? ? audio.duration : video.duration
  end
  
  def url
    audio? ? audio.url : video.url
  end
  
  def has_transcription?
    audio? ? audio.has_transcription? : video.has_transcription?
  end

  def transcription
    audio? ? audio.transcription : video.transcription
  end

  def thumbnail
    audio? ? audio.thumbnail : video.thumbnail
  end
  
  
end