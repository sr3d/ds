# encoding: utf-8

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
end


def should_change(executable, how_many = 1, &block)
  before = eval(executable)
  yield
  after = eval(executable)
  after.should == before + how_many
end



def should_not_change(executable, &block)
  before = eval(executable)
  yield
  after = eval(executable)
  after.should == before
end



OmniAuth.config.test_mode = true 
OmniAuth.config.mock_auth[:facebook] = {"provider"=>"facebook", "uid"=>"54500509", "credentials"=>{"token"=>"214272005272503|554500509|hK2H9cUk3G5GYGbOyxXSsRDQweY"}, "user_info"=>{"nickname"=>"alexnhatle", "email"=>"nworld3d@yahoo.com", "first_name"=>"Nhat", "last_name"=>"Le", "name"=>"Nhat Le", "image"=>"http://graph.facebook.com/54500509/picture?type=square", "urls"=>{"Facebook"=>"http://www.facebook.com/alexnhatle", "Website"=>nil}}, "extra"=>{"user_hash"=>{"id"=>"54500509", "name"=>"Nhat Minh Le", "first_name"=>"Nhat", "middle_name"=>"Minh", "last_name"=>"Le", "link"=>"http://www.facebook.com/alexnhatle", "username"=>"alexnhatle", "hometown"=>{"id"=>"108724149156796", "name"=>"Thanh Pho Ho Chi Minh, Hồ Chí Minh, Vietnam"}, "location"=>{"id"=>"108089905886149", "name"=>"Fremont, California"}, "bio"=>"Geek, Music Lover, Web Developer, Entrepreneur, Standup/Sitdown Comedian, Risk Taker, Chef, and all around awesomeness.", "work"=>[{"employer"=>{"id"=>"165286510151892", "name"=>"Marrily"}, "location"=>{"id"=>"108089905886149", "name"=>"Fremont, California"}, "position"=>{"id"=>"148485888500795", "name"=>"Founder"}, "description"=>"Single Founder, bootstrapper of the most awesome wedding planner.", "start_date"=>"2010-05"}, {"employer"=>{"id"=>"114802141867947", "name"=>"Designkitchen"}, "location"=>{"id"=>"108659242498155", "name"=>"Chicago, Illinois"}, "description"=>"Tech-lead on www.clubbk.com and other Burger King-related projects.  Ironically I didn't eat at BK during the entire time.  Weird.", "start_date"=>"2008-10", "end_date"=>"2009-08"}, {"employer"=>{"id"=>"110334648994615", "name"=>"BridgePoint Technologies"}, "position"=>{"id"=>"139966739368093", "name"=>"IT Consultant"}, "start_date"=>"2007-07", "end_date"=>"2008-10"}, {"employer"=>{"id"=>"122627971090510", "name"=>"Custom Data Processing"}, "location"=>{"id"=>"103099933063495", "name"=>"La Grange, Illinois"}, "position"=>{"id"=>"137221592980321", "name"=>"Developer"}, "description"=>"Keep the servers from smokin', besides, I have the best job in the world.", "start_date"=>"2006-09", "end_date"=>"2007-07"}], "education"=>[{"school"=>{"id"=>"115034031842078", "name"=>"Gia Dinh High School"}, "type"=>"High School"}, {"school"=>{"id"=>"113208945360741", "name"=>"Lake Forest College"}, "year"=>{"id"=>"137616982934053", "name"=>"2006"}, "concentration"=>[{"id"=>"104076956295773", "name"=>"Computer Science"}, {"id"=>"113496838660747", "name"=>"Chemistry"}], "type"=>"College"}], "gender"=>"male", "email"=>"nworld3d@yahoo.com", "timezone"=>-7, "locale"=>"en_US", "languages"=>[{"id"=>"104059856296458", "name"=>"Vietnamese"}, {"id"=>"106059522759137", "name"=>"English"}, {"id"=>"179987208700646", "name"=>"language of the heart"}], "verified"=>true, "updated_time"=>"2011-07-21T01:47:45+0000"}}}
