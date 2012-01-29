class InterviewsController < ApplicationController
  before_filter :authenticate_user!
  
  def show 
    @event = Event.find params[:event_id]
    @interview = Interview.find params[:id]
  end


  def new
    @event = Event.find params[:event_id]
    @interview = current_user.interviews.new 
  end


  def create
    @event = Event.find params[:event_id]
    @video = Video.create_from_params params[:interview], current_user
    redirect_to event_path @event.id # :controller => "events", :action => "show", :
  end
end