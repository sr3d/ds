class Attendant < ActiveRecord::Base
  include AASM  
  belongs_to :event
  belongs_to :user
  belongs_to :invite
  
  validates_presence_of :event_id
  validates_presence_of :user_id, :if => proc { |a| a.invite_id.blank? }
  validates_presence_of :invite_id, :if => proc { |a| a.user_id.blank? }
  validates_uniqueness_of :user_id, :scope => :event_id, :unless => proc { |a| a.user_id.blank? }
  validates_uniqueness_of :invite_id, :scope => :event_id, :unless => proc { |a| a.invite_id.blank? }
  
  scope :pending, where(:rsvp_status => :pending)
  scope :active, where( :rsvp_status => [:maybe, :attending])
  
  def full_name; user ? user.full_name : invite.full_name end
  def email; user ? user.email : invite.email; end

  # https://github.com/rubyist/aasm
  # http://railsmagazine.com/articles/26
  aasm_column :rsvp_status
  aasm_initial_state :pending  # starting out, user is still updating the campaign info
  aasm_state :pending    # awaiting user's input
  aasm_state :attending  # 
  aasm_state :maybe      # user is indecisive
  aasm_state :not_going  # 
  
  aasm_event :accept_rsvp do
    transitions :to => :attending, :from => [ :attending, :pending, :not_going, :maybe ]
  end
  
  aasm_event :decline_rsvp do
    transitions :to => :not_going, :from => [:pending, :attending, :maybe ]
  end
  
  aasm_event :maybe_going do
    transitions :to => :maybe, :from => [:pending, :attending, :not_going ]
  end
  
  def switch_from_invite_to_user! user
    self.invite_id = nil
    self.user_id = user.is_a?(User) ? user.id : user
    self.save!
  end
  
  def update_rsvp_status!(status)
    case status
    when 'attending' then accept_rsvp!
    when 'maybe'     then maybe_going!
    when 'not_going' then decline_rsvp!
    end
  end
  
end