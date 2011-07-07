# Include hook code here
require 'acts_as_metadata'
ActiveRecord::Base.send(:include, ActiveRecord::Acts::MetaData)
require File.dirname(__FILE__) + '/lib/acts_as_metadata'
require File.dirname(__FILE__) + '/lib/metadata_activerecord'
# require 'lib/acts_as_metadata.rb'