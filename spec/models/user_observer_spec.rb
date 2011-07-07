require 'spec_helper'

describe UserObserver do
  before do
    @user = Factory(:user)
    
    @email = Factory.attributes_for(:user)[:email]
    @invited_user = Factory(:user, :email => @email)
    
    # build the invite
    @invite = Factory(:invite, :user => @user, :email => @email)
    @observer = UserObserver.instance
  end

  describe 'after creating user' do
    it 'should make friends automatically' do
      @invited_user.should_receive(:make_friend_with).with(@user)
      @observer.after_create(@invited_user)
    end
    
    it 'should make friend successfully' do
      @observer.after_create(@invited_user)
      @user.friends.reload
      @user.friends.should include @invited_user
      @invited_user.friends.should include @user 
    end
        
    it 'should remove the invite' do
      lambda { @observer.after_create(@invited_user) }.should change(Invite, :count).by(-1)
    end
  end
  
  describe 'with event invitation' do
    before do
      @event = Factory(:event, :user => @user)
      @event.invite [@invite]       # invite the other_user to the event
    end
    
    it 'should not change the attendants list' do
      lambda{ @observer.after_create(@invited_user) }.should_not change(Attendant, :count)
    end
    
    it 'should convert the attendant from using the invite to the right user' do
      @event.attendants.first.user.should == @other_user
    end
  end
end
