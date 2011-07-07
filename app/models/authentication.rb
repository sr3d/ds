class Authentication < ActiveRecord::Base
  belongs_to :user
  
  class << self
    def create_from_omniauth(omniauth, user)
      create! :user => user,
              :provider => omniauth['provider'], :uid => omniauth['uid'], 
              :token => omniauth['credentials']['token'], :secret => omniauth['credentials']['secret']
    end
  end
  
end
