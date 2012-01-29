class TwilioCallbackController < ApplicationController
  before_filter :find_user
  
  
  def index
    respond_to do |format|
      format.xml do
        xml = <<-XML
        <Response>
          
        </Response>
        XML
        render :text => xml
        # if params[:Digits] == "1"
        #   
        # else
        #   render :action => 'first_prompt', :layout => false
        # end
      end
    end
  end
  
  
  def receive_voice_recording
    
  end
  
  private
  def find_user
    current_user = User.find_by_phone params[:From]
  end
  
  
  
end
