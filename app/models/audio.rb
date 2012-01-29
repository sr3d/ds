class Audio < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user_id, :url, :description

end
