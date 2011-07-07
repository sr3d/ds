# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

EventType.destroy_all
[
  [1, 'Dinner'],
  [2, 'Chilling']
].each do |event|
  e = EventType.new :name => event[1]
  e.id = event[0]
  e.save!
end