require 'spec_helper'

describe HomeController do
  include Devise::TestHelpers
  
  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end
  
  describe 'from invite' do
    before(:each) do
      session.delete :invite_email
    end
    
    it 'should persist invite_email to session' do
      user = Factory.attributes_for(:user)
      session[:invite_email].should == nil 
      get 'invite_facebook_sign_up', :invite_email => user[:email]
      session[:invite_email].should == user[:email]
      response.should redirect_to('/users/auth/facebook')
    end
    
  end

  describe 'logged in user' do
    before(:each) do
      @user = Factory(:user)
      sign_in @user
    end
    
    it 'should redirect to events#index' do
      get 'index'
      response.should redirect_to(events_path)
    end
  end

end
