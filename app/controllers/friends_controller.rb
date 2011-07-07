class FriendsController < ApplicationController
  
  def index
  end

  # GET /friends/invite
  # POST /friends/invite
  def invite
    if request.post? and params[:contact_list]
      current_user.invite params[:contact_list].split(/,/)
      current_user.update_attributes :has_invited_friends => true
      # current_user.save
      flash[:notice] = "Inviting friends successfully"
      redirect_to :action => "index"
    end
  end
end
