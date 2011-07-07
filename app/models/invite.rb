require "digest/sha1"
class Invite < ActiveRecord::Base
  
  belongs_to :user
  has_many :attendants # don't use :dependent => destroy here because we'll be remoing the invite!
  
  attr_accessible :name, :email
  
  validates_presence_of :user_id
  validates_format_of :email, :with => /^(([a-z0-9_.-]+)@([a-z0-9-]+)\.[a-z.]+)$/i
  validates_uniqueness_of :email, :scope => [:user_id]
  
  class << self
    # build a new invite 
    def build_and_create_invite(friend, user)
      invite = Invite.new
      invite.email = (friend.scan(/((?:[a-z0-9_.-]+)@(?:[a-z0-9-]+)\.[a-z.]+)/i).flatten.first || "" ).downcase.strip

      # clean email + sanitize to get the name
      invite.name = friend.gsub(/\b<?[a-z0-9_.-]+@[a-z0-9-]+\.[a-z.]+>?\b/i, '')
      invite.name = invite.name.gsub(/["<>]/,'').strip
      
      invite.user_id = user.id
      
      # find for existing user and create friendship right away.
      unless make_friend_if_existing_user(invite.email, user)
        invite.save
        invite
      end
    end
    
    # create a new friendship if the invitee already exists
    def make_friend_if_existing_user(email, user)
      if other_user = User.find_by_email(email)
        user.make_friend_with other_user
        true
      else
        false
      end
    end
  end
  
  
  def full_name
    unless name.blank?
      "#{name} (#{email})".strip
    else
      email
    end
  end
  
  
  before_create :generate_unique_token
  def generate_unique_token
    self.token ||= ::Digest::SHA1.hexdigest('--dropsocial--' << Time.now.to_s << '--')
  end
  
end