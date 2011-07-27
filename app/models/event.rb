class Event < ActiveRecord::Base
  belongs_to :event_type
  belongs_to :user
  
  has_many :attendants, :dependent => :destroy
  
  validates_presence_of :name
  validates_numericality_of :user_id
  
  scope :between, lambda { |start_time, end_time| where( ['events.when BETWEEN ? AND ?', start_time, end_time ] ) }
  scope :upcoming, between( Date.today, 2.weeks.from_now )
  scope :current_month, between( Date.current.at_beginning_of_month, Date.current.at_end_of_month)
  scope :active, where( ['events.when >= ?', Date.today] )
  

  # used for calendar 
  def get_date
    self.when.to_date
  end
  
  
  def invite(attendants)
    current_attendants = self.attendants.clone
    current_user = self.user
    
    new_attendants = []
    
    attendants.each do |attendant|
      if attendant.is_a?(Invite)
        unless self.attendants.find_by_invite_id(attendant.id)
          new_attendants << self.attendants.create(:invite_id => attendant.id)
        end
      elsif attendant =~ /\d+(?!-)\b/
        # already an attendant, pop from the current list so that
        # at the end, anything in this list is un-invited people
        current_attendants.delete_if { |a| a.id == attendant.to_i }
        
      elsif attendant =~ /user$/ and not self.attendants.find_by_user_id(attendant.to_i)
        new_attendants << self.attendants.create(:user_id => attendant.to_i)
        
      elsif attendant =~ /invite$/ and not self.attendants.find_by_invite_id( current_user.invites.find(attendant).id )
        new_attendants << self.attendants.create( :invite_id => attendant.to_i )
      end
    end
    
    # for the remaining attendants, remove from the list
    current_attendants.each { |a| a.destroy }
    
    send_event_invite_to new_attendants
  end
  
  def send_event_invite_to(attendants)
    return if attendants.empty?
    
    all_current_attendants = self.attendants.reload
    attendants.each do |attendant|
      UserMailer.event_invite(self.user, self, attendant, all_current_attendants).deliver
    end
  end
  
  def all_attendants
    self.attendants.to_a + [self.user]
  end
  
  
  def to_formatted_time
    return @formatted_time if @formatted_time
    @formatted_time = (self.when ? self.when.strftime('%B %d, %y') : 'No Date Specified')
    @formatted_time << " at " << (self.start_time ? self.start_time.strftime('%l:%M%p') : 'No Time Specified')
    @formatted_time
  end
  
  def calendar_name
    return @calendar_name if @calendar_name
    @calendar_name = name.split(' ').first
  end
  
  
end