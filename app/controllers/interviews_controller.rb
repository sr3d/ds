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

        # 
        # 
        # @interview_data  = {}
        # @interview_data[:url] = params[:interview_url] unless params[:interview_url].blank?
        # @user = User.new
        # @user = User.find params[:user_email] unless params[:user_email]
        # if @user.id.nil? 
        #   @user = User.new params[:user_email] unless params[:user_email]
        # end
        # @interview_data[:user_id] = @user.id
        # @interview = Interview.new @interview_data
        # @video = Video.new
        # if params[:Filedata]
        #   @video = @interview.videos.create(:file_data => params[:Filedata])
        #   @video.save
        #   respond_to do |format|
        #     format.html # show.html.erb
        #     format.xml  { render :xml => @interview }
        #     format.json { render :json => @interview }
        #   end
        # 
        # end

  end
end