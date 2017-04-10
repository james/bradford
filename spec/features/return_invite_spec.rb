require "rails_helper"

RSpec.feature "User who has been before is invited again by Local Welcome", :type => :feature do
  before do
    @event1 = Event.create!(name: "Test Event 1", starts_at: "01/01/2018 15:00".to_time)
    @event2 = Event.create!(name: "Test Event 2", starts_at: "01/02/2018 15:00".to_time)
    @person = Person.create!(name: "Test User", phone_number: "012345")
    @old_attendance = Attendance.create!(event: @event1, person: @person, state: 'confirmed')
    @new_attendance = Attendance.create!(event: @event2, person: @person, state: 'new')
  end
  scenario "User clicks yes" do
    visit "/invites/#{@new_attendance.code}"

    expect(page).to have_text("Hi Test User. Thanks for attending. Will you come again?")
    expect(page).to have_text("1st Feb")
    expect(page).to have_text("3PM - 5PM")
    click_button "Yes"

    expect(page).to have_text("Great! Looking forward to it.")
    reloaded_attendance = Attendance.find(@new_attendance.id)
    expect(reloaded_attendance.state).to eq('confirmed')
    sharing_invite = reloaded_attendance.shareable_invites.first
    expect(page).to have_text(invite_path(sharing_invite.code))
  end

  scenario "User clicks no" do
    visit "/invites/#{@new_attendance.code}"

    expect(page).to have_text("Hi Test User. Thanks for attending. Will you come again?")
    expect(page).to have_text("1st Feb")
    expect(page).to have_text("3PM - 5PM")
    click_button "No"

    expect(page).to have_text("That's a shame")
    reloaded_attendance = Attendance.find(@new_attendance.id)
    expect(reloaded_attendance.state).to eq('rejected')
    sharing_invite = reloaded_attendance.shareable_invites.first
    expect(sharing_invite).to eq(nil)
  end
end
