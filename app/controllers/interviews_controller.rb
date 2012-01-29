class InterviewsController < ApplicationController
  before_filter :authenticate_user!, :except => [:upload_video]
  
  def show 
    @event = Event.find params[:event_id]
    @interview = Interview.find params[:id]
  end


  def new
    @event = Event.find params[:event_id]
    @interview = current_user.interviews.new 
  end
  
  def destroy
    @interview = Interview.find params[:id]
    @interview.destroy
    redirect_to event_path @event.id
  end


  def create
    @event = Event.find params[:event_id]
    @video = Video.create_from_params params[:interview], current_user
    redirect_to event_path @event.id # :controller => "events", :action => "show", :
  end
  
  def upload_video
    video_id = params[:video_id]
    email = params[:email]
    user = User.find_by_email(email) || User.get_demo_user
    
    Video.create_from_video_id video_id, user
    
    respond_to do |format|
      format.html { render :text => :ok }
    end
  end
  
end