require 'spec_helper'

describe EventsController do
  include Devise::TestHelpers
  
  before(:each) do
    @user = Factory(:user)
    sign_in @user
  end
  
  it 'should get index successfully' do
    get 'index'
    response.should be_success
  end
  
  it 'should get social_calendar successfully' do
    get 'social_calendar', :month => 1, :year => 2011
    response.should be_success
  end
  
  describe 'with event' do
    before(:each) do
      @event = Factory(:event, :when => Date.current, :user => @user)
    end
    
    it 'should get index successfully' do
      get 'index'
      response.should be_success
    end
  end
  
end
