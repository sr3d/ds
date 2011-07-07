require 'spec_helper'

describe Event do
  before do
    @user = Factory(:user)
    @event = Factory(:event, :user => @user)
    @invite = Factory(:invite, :user => @user)
    @other_user = Factory(:user)
  end
  
  after(:each) do
    Invite.destroy_all
  end
  
  describe 'inviting attendants' do
    it 'should add invitee as attendants' do
      should_change('ActionMailer::Base.deliveries.count') do
        lambda { @event.invite [ "#{@invite.id}-invite" ] }.should change(Attendant, :count).by(1)
      end
    end

    it 'should add user as attendants' do
      lambda { @event.invite [ "#{@other_user.id}-user" ] }.should change(Attendant, :count).by(1)
    end
    
    it 'should invite an existing invite' do
      lambda { @event.invite [ Factory(:invite, :user => @user) ] }.should change(Attendant, :count).by(1)
    end
    
    it 'should un-invite attendant as well' do
      lambda { @event.invite [ Factory(:invite, :user => @user), "#{@other_user.id}-user" ] }.should change(Attendant, :count).by(2)
      last_attendant = Attendant.last
      lambda { @event.invite [ last_attendant.id.to_s ] }.should change(Attendant, :count).by(-1)
    end
    
    it 'should remove the unvited one and keep the rest' do
      lambda { @event.invite [ Factory(:invite, :user => @user),  ] }.should change(Attendant, :count).by(1)
    end
    
    it 'should invite a mix of everything' do
      invites = [ "#{@invite.id}-invite", "#{@other_user.id}-user", Factory(:invite, :user => @user) ]
      lambda { @event.invite invites }.should change(Attendant, :count).by(invites.length)
    end
    
  end
  
  
  
  
end
