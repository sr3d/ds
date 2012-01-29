class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:authenticate]
  
  def index
  end
  
  def show
    @user = User.find params[:id]
    if current_user.is_friend_with? @user
      @events = @user.events_attending.sort{|a,b| a.when <=> b.when }
    else
      render :text => "You're not friend with this user, hence you cannot view this user's profile.", :status => 404
    end
    
  end
  
  # PUT /users/confirm_primary_email
  def confirm_primary_email  
    if current_user.update_attributes params[:user]
      current_user.primary_email_confirmed = true
      current_user.save
    end
  end 
  
  def social_calendar
    
  end

  def edit
  end

  def update
  end

  def destroy
  end
  
  
  # POST
  def authenticate
    @user = User.get_demo_user
    respond_to do |format|
      format.json { render_for_api :public, :json => @user }
    end
  end

end
