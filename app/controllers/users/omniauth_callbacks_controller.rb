class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    handle_oauth_callback
  end
  
  # http://railscasts.com/episodes/236-omniauth-part-2
  private
  def handle_oauth_callback
    omniauth = env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      Authentication.create_from_omniauth(omniauth, user)
      flash[:notice] = "Authentication successful."
      redirect_to authentications_url
    else
      user = User.find_by_email( omniauth['user_info']['email'])
      
      # if there's already a user with this email, associate the new Oauth provider with the account
      if user
        Authentication.create_from_omniauth(omniauth, user)
        sign_in_and_redirect(:user, user)
      else
        user = User.new
        user.apply_omniauth(omniauth)
        if user.save
          flash[:notice] = "Signed in successfully."
          sign_in_and_redirect(:user, user)
        else
          session[:omniauth] = omniauth.except('extra')
          redirect_to new_user_registration_url
        end
      end
      
    end
  end
end