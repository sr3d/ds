require 'video_upload'

class Video < ActiveRecord::Base
  AVAILABLE_MIME_TYPES = ['video/quicktime', 'video/mpeg', 'video/x-msvideo', 'video/mp4', 'video/mpeg4', 'video/x-ms-asf', 'video/x-ms-wmv', 'video/x-flv']

  attr_accessible :description, :interview_id, :user_id


  def self.create_from_params params, user
    # debugger
    file = IO.read(params[:video].path)
    client = YouTubeG::Upload::VideoUpload.new
    youtube_code = client.upload file, nil
    video = Video.create :video_id => youtube_code, :url => "http://", :user_id => user.id
    interview = Interview.new :user_id => user.id, :video => video
    interview  # BLAH!  blaspheme!
  end

  before_create :upload_to_youtube
  def upload_to_youtube
    unless self.youtube_code.blank?
      self.youtube_code = self.youtube_code[/v=([^&.]*)/,1] || self.youtube_code
    else
      client = YouTubeG::Upload::VideoUpload.new
      self.youtube_code = client.upload(self.file_data, self.interview)
    end
  end

  def thumbnail(size = :small)
    "http://img.youtube.com/vi/#{self.youtube_code}/#{size == :small ? 1 : 0}.jpg"
  end
end
