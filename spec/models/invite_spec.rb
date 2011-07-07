require 'spec_helper'

describe Invite do
  # pending "add some examples to (or delete) #{__FILE__}"
  before do
    @user = Factory(:user)
  end
  
  after(:each) do
    Invite.destroy_all
  end
  
  describe 'with different email formats' do
    it 'should build and create new invite' do
      lambda { 
        invite = Invite.build_and_create_invite('"Alex Le" <alex0@dropsocial.com>', @user) 
        invite.email.should == 'alex0@dropsocial.com'
        invite.name.should  == 'Alex Le'
      }.should change(Invite,:count).by(1)
      
      lambda { 
        invite = Invite.build_and_create_invite('alexle1@dropsocial.com', @user) 
        invite.email.should == 'alexle1@dropsocial.com'
        invite.name.should  == ''
      }.should change(Invite,:count).by(1)
      
      lambda { invite = Invite.build_and_create_invite('Alex alexle2@dropsocial.com', @user) 
        invite.email.should == 'alexle2@dropsocial.com'
        invite.name.should  == 'Alex'
      }.should change(Invite,:count).by(1)
    end
    
    it 'should not build and create with invalid email ' do
      lambda { @invite = Invite.build_and_create_invite('alexle_dropsocial.com', @user) }.should_not change(Invite,:count)
    end
    
  end
  
  describe 'inviting an existing user' do
    it 'should friend existing user automatically' do
      @friend = Factory(:user)
      lambda { 
        lambda { Invite.build_and_create_invite(@friend.email, @user) }.should_not change(Invite,:count)
      }.should change(Friendship, :count).by(2)
      @user.friends.reload
      @user.friends.should include @friend
      @friend.friends.should include @user
    end
  end
  
end
