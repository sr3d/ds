require 'spec_helper'

describe Users::OmniauthCallbacksController do
  include Devise::TestHelpers
  
  before(:each) do
    request.env["devise.mapping"] = Devise.mappings[:user] 
  end
  
  describe 'facebook callback' do
    it 'should create new user' do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
      @user_attributes = Factory.attributes_for(:user)
      request.env["omniauth.auth"]['user_info']['email'] = @user_attributes[:email]
      request.env["omniauth.auth"]['user_info']['uid'] = Time.now.to_i
      
      should_change 'User.count' do
        should_change 'Authentication.count' do
          get 'facebook'
        end
      end
    end
    
    
    describe 'existing user' do
      before(:each) do
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        @user = Factory(:user)
        request.env["omniauth.auth"]['user_info']['email'] = @user.email
        request.env["omniauth.auth"]['user_info']['uid'] = Time.now.to_i
      end
      
      after(:each) do
        session.delete(:invite_email)
      end
      
      it 'should only create fb authentication for existing user' do
        should_not_change 'User.count' do
          should_change 'Authentication.count' do
            get 'facebook'
          end
        end
      end

      it 'should associate with alternative email' do
        session[:invite_email] = invite_email = Factory.next(:email)
        @user.other_email.should == nil
        should_change 'UserSecondaryEmail.count' do
          should_not_change 'User.count' do
            should_change 'Authentication.count' do
              get 'facebook'
            end
          end
        end
        session[:invite_email].should == nil
        @user.reload.user_secondary_emails.map(&:email).should include(invite_email)
      end
      
    end

    
    
    
  end
  
  
  
  
  # pending "add some examples to (or delete) #{__FILE__}"
end