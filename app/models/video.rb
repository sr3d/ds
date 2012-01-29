require 'video_upload'

class Video < ActiveRecord::Base
  AVAILABLE_MIME_TYPES = ['video/quicktime', 'video/mpeg', 'video/x-msvideo', 'video/mp4', 'video/mpeg4', 'video/x-ms-asf', 'video/x-ms-wmv', 'video/x-flv']

  attr_accessible :description, :interview_id, :user_id, :video_id, :url


  def self.create_from_params params, user
    # debugger
    file = IO.read(params[:video].path)
    client = YouTubeG::Upload::VideoUpload.new
    debugger
    youtube_code = client.upload file, nil
    video = Video.create :video_id => youtube_code, :url => "http://", :user_id => user.id
    interview = Interview.new :user_id => user.id, :video_id => video.id
    interview  # BLAH!  blaspheme!
  end

  def thumbnail(size = :small)
    "http://img.youtube.com/vi/#{video_id}/#{size == :small ? 1 : 0}.jpg"
  end
  
  def has_transcription?
    false
  end
  
end
