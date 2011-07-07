class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # private
  def after_sign_in_path_for(resource)
    if resource.is_a? User
      unless resource.has_invited_friends
        '/friends/invite'
      else
        '/events'
      end
    else
      '/'
    end
  end  
  
end
