require 'spec_helper'

describe User do
  before do
    @user = Factory(:user)
  end
  
  after(:each) do
    User.destroy_all
  end
  
  describe 'managing friendship' do
    it 'should create a mutual friendship with another user' do
      @other_user = Factory(:user)
      lambda { @user.make_friend_with @other_user }.should change(Friendship,:count).by(2)
      @user.friends.reload.should include @other_user
      @other_user.friends.should include @user
    end
  end
  
  describe 'with secondary emails' do
    it 'should add new secondary_email' do
      secondary_email = Factory.next(:email)
      lambda { @user.add_secondary_email secondary_email }.should change(UserSecondaryEmail, :count).by(1)
    end
  end
  
end