class ApplicationController < ActionController::Base
  # before_filter :extract_invite_email_before_auth
  protect_from_forgery
  
  # private
  def after_sign_in_path_for(resource)
    if resource.is_a? User
      if resource.has_invited_friends
        '/friends/invite'
      else
        '/events'
      end
    else
      '/'
    end
  end
  
  
  
end
