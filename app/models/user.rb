class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  has_many :authentications, :dependent => :destroy
  has_many :friendships
  has_many :friends, :through => :friendships, :class_name => 'User'
  has_many :invites, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :attendants, :dependent => :destroy

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :gender

  acts_as_metadata :meta => ['primary_email_confirmed', 'has_invited_friends']
  
  
  def apply_omniauth(omniauth)
    self.email = omniauth['user_info']['email'] if email.blank?
    if user_hash = omniauth['extra']['user_hash'] && omniauth['extra']['user_hash']
      self.first_name ||= user_hash['first_name']
      self.last_name  ||= user_hash['last_name']
      self.gender     ||= user_hash['gender']
    end
    authentications.build :provider => omniauth['provider'], :uid => omniauth['uid'], 
                          :token => omniauth['credentials']['token'], :secret => omniauth['credentials']['secret']
  end
  
  # override with Devise
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end
  
  def full_name
    "#{first_name} #{last_name}".strip
  end

  
  def can_edit_event?(event)
    return self.id == event.user_id
  end
  
  
  def all_friends_and_pending_invites
    return @all_friends_and_pending_invites if @all_friends_and_pending_invites
    all_friends = friends
    invites = self.invites.all
    @all_friends_and_pending_invites = (all_friends + invites).sort_by{ |f| f.full_name }
  end
  
  
  def invite emails
    invites = []
    emails.each do |email|
      invites << Invite.build_and_create_invite(email, self)
    end
    invites
  end
  
  
  # this is a psue-do column for user who creates the event
  # will automatically attending the event
  def rsvp_status
    'attending'
  end
  
  
  def make_friend_with other_user
    unless self.id == other_user.id
      # currently a mutual friendship is done through 2 separated friendship records
      # so that it's easier to query for friends (though this isn't the most optimized way to do so)
      Friendship.find_or_create_by_user_id_and_friend_id(self.id, other_user.id)
      Friendship.find_or_create_by_user_id_and_friend_id(other_user.id, self.id)
    end
  end
  
  def is_friend_with? other_user
    other_user.id == self.id || friends.include?(other_user)
  end
  
  def can_view_event? event
    event.user_id == self.id || event.attendants.map(&:user_id).include?(self.id)
  end
  
  def events_attending
    return @active_events if @active_events
    # my own events
    @active_events = self.events.active.all 
    
    # events i'm attending
    @active_events.concat self.attendants.active.all(:include => [:event]).collect{|a| a.event}
    
    @active_events
  end
  
  
end