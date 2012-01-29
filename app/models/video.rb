require 'video_upload'

class AdVideo < ActiveRecord::Base
  AVAILABLE_MIME_TYPES = ['video/quicktime', 'video/mpeg', 'video/x-msvideo', 'video/mp4', 'video/mpeg4', 'video/x-ms-asf', 'video/x-ms-wmv', 'video/x-flv']
  
  belongs_to :interview
  

  
  # Validations
  validates_attachment_content_type :video, 
                                    :content_type => AVAILABLE_MIME_TYPES,
                                    :message => 'Video file must have an extension .mov, .mp4, or .avi.'
  validates_attachment_size :video, :in => 1..512.megabyte
  
  attr_protected :video_file_name, :video_content_type, :video_size
  attr_accessor :file_data

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
