class InterviewsController < ApplicationController

  def show 
    @event = Event.find params[:event_id]
    @interview = Interview.find params[:id]
  end
  
end
