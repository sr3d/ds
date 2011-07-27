class HomeController < ApplicationController
  def index
    redirect_to :controller => "events", :action => "index" if user_signed_in?
  end
  
  def invite_facebook_sign_up
    # a hack here to save the email to the session data
    if params[:invite_email]
      session[:invite_email] = params[:invite_email]
    end
    redirect_to "/users/auth/facebook"
  end
  
end
