class InterviewsController < ApplicationController

  def show 
    @event = Event.find params[:event_id]
    @interview = Interview.find params[:id]
    @interview_data  = {}
    @interview_data[:url] = params[:interview_url] unless params[:interview_url].blank?
    @user = User.new
    @user = User.find params[:user_email] unless params[:user_email]
    if @user.id.nil? 
      @user = User.new params[:user_email] unless params[:user_email]
    end
    @interview_data[:user_id] = @user.id
    @interview = Interview.new @interview_data

      
    respond_to do |format|
       format.html # show.html.erb
       format.xml  { render :xml => @interview }
       format.json { render :json => @interview }
    end
  
end
