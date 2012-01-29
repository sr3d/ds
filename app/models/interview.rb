class Interview < ActiveRecord::Base
  belongs_to :user
  belongs_to :audio
  
  def audio?
    !audio_id.nil?
  end
  
  def duration
    audio ? audio.duration : video.duration
  end
  
  def url
    audio ? audio.url : video.url
  end
  
end