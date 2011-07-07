class UserObserver < ActiveRecord::Observer
  def after_create(user)
    check_invitations(user)
  end
  
  private 
  def check_invitations(user)
    Invite.find_all_by_email(user.email.downcase, :include => [:user, :attendants]).each do |invite|
      # make friend automatically
      user.make_friend_with invite.user

      # switch the attendants 
      invite.attendants.each do |attendant|
        attendant.switch_from_invite_to_user! user
      end
      
      invite.destroy
    end
  end
end