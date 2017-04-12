require "rails_helper"

RSpec.feature "New user is invited by a friend", :type => :feature do
  before do
    @event = Event.create!(name: "Test Event 1", starts_at: "01/01/2018 15:30".to_time)
    @inviter = Person.create!(name: "Test Invitee", phone_number: "012345")
    @attendance = Attendance.create!(event: @event, invitee: @inviter, state: 'new')
  end
  scenario "User clicks yes" do
    visit "/invites/#{@attendance.code}"

    expect(page).to have_text("Test Invitee is attending a Local Welcome event")
    expect(page).to have_text("1st Jan")
    expect(page).to have_text("3:30PM - 5:30PM")

    fill_in "Name", with: "New Test"
    fill_in "Phone number", with: "0123456789"
    click_button "I can come!"

    expect(page).to have_text("Great! Looking forward to it.")
    reloaded_attendance = Attendance.find(@attendance.id)
    expect(reloaded_attendance.state).to eq('confirmed')
    expect(reloaded_attendance.person.name).to eq("New Test")
    expect(reloaded_attendance.person.phone_number).to eq("0123456789")
    sharing_invite = reloaded_attendance.shareable_invites.first
    expect(sharing_invite).to eq(nil)
  end

  scenario "User clicks no" do
    visit "/invites/#{@attendance.code}"

    expect(page).to have_text("Test Invitee is attending a Local Welcome event")
    expect(page).to have_text("1st Jan")
    expect(page).to have_text("3:30PM - 5:30PM")
    click_button "I can't come"

    expect(page).to have_text("That's a shame")
    reloaded_attendance = Attendance.find(@attendance.id)
    expect(reloaded_attendance.state).to eq('rejected')
    sharing_invite = reloaded_attendance.shareable_invites.first
    expect(sharing_invite).to eq(nil)
  end
end
