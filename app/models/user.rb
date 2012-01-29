class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  has_many :authentications, :dependent => :destroy
  has_many :user_secondary_emails, :dependent => :destroy
  has_many :friendships
  has_many :friends, :through => :friendships, :class_name => 'User'
  has_many :invites, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :attendants, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :audios, :dependent => :destroy
  has_many :interviews, :dependent => :destroy
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :gender

  

  acts_as_metadata :meta => ['primary_email_confirmed', 'has_invited_friends']
  
  class << self
    # Find the user using both the primary email and the secondary email
    def find_by_email(email)
      if user = User.find(:first, :conditions => { :email => email })
        return user
      end
      secondary_email = UserSecondaryEmail.find_by_email(email, :include => :user )
      return secondary_email.user if secondary_email
    end
    
    
    def get_demo_user
      if user = User.find_by_email("alexle@marrily.com")
        return user
      end
      user = User.create! :email => 'alexle@marrily.com', :first_name => 'Alex', :last_name => 'Le',
        :password => '123456', 
        :password_confirmation => '123456'
      user
    end
    
    
    def find_by_phone(phone)
      # return user if user = User.find_by_phone phone
      # user = User.new :phone => phone
      get_demo_user
    end
    
  end
  
  # make sure the primary email isn't saved already in the secondary_email
  def validate_primary_with_secondary_email
    if UserSecondaryEmail.find_by_email(email, :conditions => ['user_id != ?', self.id] )
      errors.add(:email, 'Secondary email have been already taken')
    end
  end
  validate :validate_primary_with_secondary_email
  
  
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
  
  def events_attending(date = Date.today)
    return @active_events if @active_events
    @active_events = self.events.between(date.at_beginning_of_month, date.at_end_of_month)
    # events i'm attending
    @active_events.concat self.attendants.active.all(:include => [:event]).collect{|a| a.event}
    @active_events
  end
  
  def events_attending_between(begin_date, end_date)
    my_events = self.events.between(begin_date, end_date)
    invited_events = self.attendants.active.joins(:event).where(['events.when BETWEEN ? AND ?', begin_date, end_date]).map(&:event)
    my_events.concat invited_events
  end
  

  def add_secondary_email(email)
    email = email.strip.downcase
    secondary_email = self.user_secondary_emails.new(:email => email)
    secondary_email.save
  end


  def profile_image_url
    return @profile_image_url if @profile_image_url 
    facebook_uid = authentications.select{ |a| a.provider == 'facebook' }.first.uid
    @profile_image_url = "http://graph.facebook.com/#{facebook_uid}/picture?type=square"
  end

  # profile image can be called:
  # http://graph.facebook.com/54500509/picture?type=large
  
  
  acts_as_api

  api_accessible :public do |template|
    template.add :email
    template.add :phone
    template.add :api_token
  end
end