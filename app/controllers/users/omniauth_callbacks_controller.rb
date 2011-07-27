class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    handle_oauth_callback
  end
  
  # http://railscasts.com/episodes/236-omniauth-part-2
  private
  def handle_oauth_callback
    # debugger
    @omniauth = request.env["omniauth.auth"]
    @authentication = Authentication.find_by_provider_and_uid(@omniauth['provider'], @omniauth['uid'])
    if @authentication
      sign_in_for_existing_oauth_authentication
    elsif current_user
      oauth_sign_in_for_current_user
    else
      new_oauth_sign_up
    end
  end
  
  def sign_in_for_existing_oauth_authentication
    @user = @authentication.user
    check_secondary_email
    sign_in_and_redirect(:user, @user)    
  end
  
  def oauth_sign_in_for_current_user
    @user = current_user
    Authentication.create_from_omniauth(@omniauth, @user)
    check_secondary_email
    redirect_to authentications_url    
  end
  
  
  def new_oauth_sign_up
    @user = User.find_by_email(@omniauth['user_info']['email'])
    # if there's already a user with this email, associate the new Oauth provider with the account
    if @user
      Authentication.create_from_omniauth(@omniauth, @user)
      check_secondary_email
      sign_in_and_redirect(:user, @user)
    else
      @user = User.new
      @user.apply_omniauth(@omniauth)
      if @user.save
        check_secondary_email
        sign_in_and_redirect(:user, @user)
      else
        # can't save the user, redirect to new page
        session[:omniauth] = @omniauth.except('extra')
        redirect_to new_user_registration_url
      end
    end
  end
  
  # associate the other email address of the users to the account
  def check_secondary_email
    if session[:invite_email]
      email = session[:invite_email]
      @user.add_secondary_email email
      session.delete(:invite_email)
    end
  end
end