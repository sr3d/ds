class AddRsvpStatusToAttendants < ActiveRecord::Migration
  def self.up
    add_column :attendants, :rsvp_status, :string, :after => :is_co_organizer
  end

  def self.down
    remove_column :attendants, :rsvp_status
  end
end
