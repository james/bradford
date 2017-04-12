require 'rails_helper'

RSpec.describe InvitesController, type: :controller do
  describe "confirmation_message" do
    before do
      @event = Event.create!(name: "Test Event 1", starts_at: "01/01/2017 15:00".to_time, location: "Location")
      @person = Person.create!(name: "Test User", phone_number: "012345")
      @new_attendance = Attendance.create!(event: @event, person: @person, state: 'new')
    end
    it "should include share link if they have an invite" do
      @invite_attendance = Attendance.create!(event: @event, invitee: @person, state: 'new')
      message = controller.send(:confirmation_message, @new_attendance)
      expect(message).to eq("Hi Test. We look forward to seeing at the Local Welcome event. The details are:
1st Jan 3:00PM - Location

Remember you have a an invite to invite a friend. Just send them this link: #{short_invite_url(@invite_attendance.code)}"
      )
    end

    it "should not include a share link if they don't have an invite" do
      message = controller.send(:confirmation_message, @new_attendance)
      expect(message).to eq("Hi Test. We look forward to seeing at the Local Welcome event. The details are:
1st Jan 3:00PM - Location")
    end
  end
end
