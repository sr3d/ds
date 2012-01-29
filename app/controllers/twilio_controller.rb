<<<<<<< HEAD
class TwilioController < BaseController
=======

ACCOUNT_SID = 'AC598c05e863827c7a7fffa351490f10d2'
ACCOUNT_TOKEN = '30e6c94ccfe7ade6040bff3c4734e8fe'

# version of the Twilio REST API to use
API_VERSION = '2010-04-01'

# base URL of this application
BASE_URL =  "localhost:3000" #production ex: "http://appname.heroku.com/callme"
>>>>>>> adding interview model and migration

# Outgoing Caller ID you have previously validated with Twilio
CALLER_ID = '267-218-0680'

class TwilioController < BaseController



<<<<<<< HEAD
  # Outgoing Caller ID you have previously validated with Twilio
  CALLER_ID = '267-218-0680'
  def index
  end


  # Use the Twilio REST API to initiate an outgoing call
  def makecall
    if !params['number']
      redirect_to({ :action => '.', 'msg' => 'Invalid phone number' })
      return
    end

    # parameters sent to Twilio REST API
    d = {
      'From' => CALLER_ID,
      'To' => params['number'],
      'Url' => BASE_URL + '/hellomoto.xml',
    }
    begin
      account = Twilio::RestAccount.new(ACCOUNT_SID, ACCOUNT_TOKEN)
      resp = account.request(
      "/#{API_VERSION}/Accounts/#{ACCOUNT_SID}/Calls",
      'POST', d)
      resp.error! unless resp.kind_of? Net::HTTPSuccess
    rescue StandardError => bang
      redirect_to({ :action => '.', 'msg' => "Error #{ bang }" })
      return
    end

    redirect_to({ :action => '', 'msg' => "Calling #{ params['number'] }..." })
=======
def index
end
>>>>>>> adding interview model and migration

  end

<<<<<<< HEAD
  # TwiML response that says the hellomoto to the caller and presents a
  # short menu: 1. repeat the msg, 2. directions, 3. good bye
  def hellomoto
    @postto = BASE_URL + '/directions.xml'

    respond_to do |format|
      format.xml { @postto }
    end
  end

  # TwiML response that inspects the caller's menu choice:
  # - says good bye and hangs up if the caller pressed 3
  # - repeats the menu if caller pressed any other digit besides 2 or 3
  # - says the directions if they pressed 2 and redirect back to menu
  def directions
    if params['Digits'] == '3'
      redirect_to BASE_URL + "/goodbye.xml"
      return
    end

    if !params['Digits'] or params['Digits'] != '2'
      redirect_to BASE_URL + "/hellomoto.xml" 
      return
    end

    @redirectto = BASE_URL + '/hellomoto.xml',
    respond_to do |format|
      format.xml { @redirectto }
    end
  end

  # TwiML response saying the goodbye message. Twilio will detect no
  # further commands after the Say and hangup
  def goodbye
    respond_to do |format|
      format.xml
    end
  end

end
=======
        # Use the Twilio REST API to initiate an outgoing call
               def makecall
                 
                   if !params['number']
                       redirect_to({ :action => '.', 'msg' => 'Invalid phone number' })
                       return
                   end
        
                   # parameters sent to Twilio REST API
                   d = {
                       'From' => CALLER_ID,
                       'To' => params['number'],
                       'Url' => BASE_URL + '/hellomoto.xml'
                   }
                   begin
                       account = Twilio::REST::Client.new('AC598c05e863827c7a7fffa351490f10d2', '30e6c94ccfe7ade6040bff3c4734e8fe')
                       
                       resp = account.request(
                           "/2010-04-01/Accounts/#{ACCOUNT_SID}/Calls",
                           'POST', d)
                       resp.error! unless resp.kind_of? Net::HTTPSuccess
                   rescue StandardError => bang
                       redirect_to({ :action => '.', 'msg' => "Error #{ bang }" })
                       return
                   end
        
                   redirect_to({ :action => '', 'msg' => "Calling #{ params['number'] }..." })
        
               end
        
               # TwiML response that says the hellomoto to the caller and presents a
               # short menu: 1. repeat the msg, 2. directions, 3. good bye
               def hellomoto
                   @postto = BASE_URL + '/directions.xml'
        
                   respond_to do |format|
                       format.xml { @postto }
                   end
               end
        
               # TwiML response that inspects the caller's menu choice:
               # - says good bye and hangs up if the caller pressed 3
               # - repeats the menu if caller pressed any other digit besides 2 or 3
               # - says the directions if they pressed 2 and redirect back to menu
               def directions
                   if params['Digits'] == '3'
                       redirect_to BASE_URL + "/goodbye.xml"
                       return
                   end
        
                   if !params['Digits'] or params['Digits'] != '2'
                       redirect_to BASE_URL + "/hellomoto.xml" 
                       return
                   end
        
                   @redirectto = BASE_URL + '/hellomoto.xml',
                   respond_to do |format|
                       format.xml { @redirectto }
                   end
               end
        
               # TwiML response saying the goodbye message. Twilio will detect no
               # further commands after the Say and hangup
               def goodbye
                   respond_to do |format|
                       format.xml
                   end
               end
        
           
>>>>>>> adding interview model and migration
end
