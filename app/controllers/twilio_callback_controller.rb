class TwilioCallbackController < ApplicationController
  before_filter :find_user
  
  def index
    respond_to do |format|
      format.xml do
        digits = params[:Digits]
        # PIN:  9441-2138
        if digits == "1"
          xml = <<-XML
          <Response>
            <Say>Please leave a message at the beep.  Press the hash or pound key when finished.</Say>
            <Record action="/twilio_callback/receive_voice_recording.xml" method="GET" maxLength="60" finishOnKey="#" />
            <Say>I did not receive any recording.  Please try again.</Say>
          </Response>
          XML
          
        # Handling default
        elsif
          
          # Started GET "/twilio_callback/index.xml?AccountSid=AC598c05e863827c7a7fffa351490f10d2&ToZip=94949&FromState=IL&Called=%2B14155992671&FromCountry=US&CallerCountry=US&CalledZip=94949&Direction=inbound&FromCity=LAKE+FOREST&CalledCountry=US&CallerState=IL&CallSid=CA3de81bdf7ac3bc59090a3cace03b97c5&CalledState=CA&From=%2B12244361127&CallerZip=60037&FromZip=60037&CallStatus=in-progress&ToCity=NOVATO&ToState=CA&To=%2B14155992671&ToCountry=US&CallerCity=LAKE+FOREST&ApiVersion=2010-04-01&Caller=%2B12244361127&CalledCity=NOVATO&DialStatus=answered" for 127.0.0.1 at 2012-01-28 17:52:55 -0800
          #   Processing by TwilioCallbackController#index as XML
          #   Parameters: {"AccountSid"=>"AC598c05e863827c7a7fffa351490f10d2", "ToZip"=>"94949", "FromState"=>"IL", "Called"=>"+14155992671", "FromCountry"=>"US", "CallerCountry"=>"US", "CalledZip"=>"94949", "Direction"=>"inbound", "FromCity"=>"LAKE FOREST", "CalledCountry"=>"US", "CallerState"=>"IL", "CallSid"=>"CA3de81bdf7ac3bc59090a3cace03b97c5", "CalledState"=>"CA", "From"=>"+12244361127", "CallerZip"=>"60037", "FromZip"=>"60037", "CallStatus"=>"in-progress", "ToCity"=>"NOVATO", "ToState"=>"CA", "To"=>"+14155992671", "ToCountry"=>"US", "CallerCity"=>"LAKE FOREST", "ApiVersion"=>"2010-04-01", "Caller"=>"+12244361127", "CalledCity"=>"NOVATO", "DialStatus"=>"answered"}
          #   User Load (0.4ms)  SELECT `users`.* FROM `users` WHERE `users`.`email` = 'alexle@marrily.com' LIMIT 1
          # Rendered text template (0.0ms)
          # Completed 200 OK in 7ms (Views: 1.0ms | ActiveRecord: 0.4ms)
          
          
          # <Gather action="handle-screen-input.php" numDigits="1">
          #         <Say>You have an incoming call.</Say>
          #         <Say>To accept the call, press 1.</Say>
          #         <Say>To reject the call, press any other key.</Say>
          #     </Gather>  
          xml = <<-XML
          <Response>
            <Gather action="/twilio_callback/index.xml" method="GET" numDigits="1">
              <Say>Welcom to DSchool App.  Press 1 to start recording the conversation.</Say>
            </Gather>
          </Response>
          XML
        end
        render :text => xml
      end
    end
  end
  
  
  def receive_voice_recording
    # saving the audio files.
    # http://api.twilio.com/2010-04-01/Accounts/AC598c05e863827c7a7fffa351490f10d2/Recordings/REe0a2e683a142a1e2f766801b574d4e53"
    # {"AccountSid"=>"AC598c05e863827c7a7fffa351490f10d2", "ToZip"=>"94949", "FromState"=>"IL", "Called"=>"+14155992671", 
    # "FromCountry"=>"US", "CallerCountry"=>"US", "CalledZip"=>"94949", "Direction"=>"inbound", "FromCity"=>"LAKE FOREST", "CalledCountry"=>"US", "CallerState"=>"IL",
    # "CallSid"=>"CA221f7db0cefaae261d03bb5dfe5e1e7b", "CalledState"=>"CA", "From"=>"+12244361127", "CallerZip"=>"60037", "FromZip"=>"60037", "CallStatus"=>"in-progress",
    # "ToCity"=>"NOVATO", "ToState"=>"CA", "RecordingUrl"=>"http://api.twilio.com/2010-04-01/Accounts/AC598c05e863827c7a7fffa351490f10d2/Recordings/REe0a2e683a142a1e2f766801b574d4e53", "To"=>"+14155992671", "Digits"=>"#", "ToCountry"=>"US", 
    # "RecordingDuration"=>"15", "CallerCity"=>"LAKE FOREST", "ApiVersion"=>"2010-04-01", "Caller"=>"+12244361127", 
    # "CalledCity"=>"NOVATO", "RecordingSid"=>"REe0a2e683a142a1e2f766801b574d4e53"}

    audio = @user.audios.create :url => params[:RecordingUrl], :duration => params[:RecordingDuration]
    interview = @user.interviews.create :audio_id => audio.id
    # audio = @user.audiointerview.audio.new :url => params[:RecordingUrl], :duration => params[:RecordingDuration], :user_id => @user.id
    respond_to do |format|
      format.xml do
        xml = <<-XML
        <Response>
          <Gather action="/twilio_callback/index.xml" method="GET" numDigits="#">
            <Say>Awesome!  Your voice interview has been saved. Hit Hash or Pound to return to the index page.</Say>
          </Gather>          
        </Response>
        XML
        render :text => xml
      end
    end
  end
  
  private
  def find_user
    @user = current_user = User.find_by_phone(params[:From])
  end
  
  
  
end
