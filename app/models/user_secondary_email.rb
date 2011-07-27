class UserSecondaryEmail < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :email
  
  validate :validate_existing_primary_email
  def validate_existing_primary_email
    if User.find_by_email email
      errors.add(:email, 'existing primary email')
    end
  end
end