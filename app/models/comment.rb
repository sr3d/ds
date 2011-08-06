class Comment < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  
  validates_presence_of :comment

  def self.latest(number_of_comments = 20)
    order(:id => :desc).limit(number_of_comments)
  end
  
  after_create :notify_all_active_attendants
  def notify_all_active_attendants
    # event.
  end
  
end
