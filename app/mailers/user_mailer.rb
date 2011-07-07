class UserMailer < ActionMailer::Base
  default :from => "no-reply@dropsocial.com"
  
  def dropsocial_invite(invite)
    
  end
  
  def event_invite(user, event, attendant, all_attendants)
    @fbconnect_url = "http://#{default_url_options[:host]}/users/auth/facebook"
    @user, @event, @attendant, @all_attendants  = user, event, attendant, all_attendants
    mail(:to => attendant.email, :subject => "Someone invites you to an event")
  end
end