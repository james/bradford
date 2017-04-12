require "rails_helper"

RSpec.feature "User who has been before is invited again by Local Welcome", :type => :feature do
  before(:each) do
    @event1 = Event.create!(name: "Test Event 1", starts_at: "01/01/2017 15:00".to_time)
    @event2 = Event.create!(name: "Test Event 2", starts_at: "01/02/2018 15:00".to_time)
    @person = Person.create!(name: "Test User", phone_number: "012345")
    @old_attendance = Attendance.create!(event: @event1, person: @person, state: 'confirmed')
    @new_attendance = Attendance.create!(event: @event2, person: @person, state: 'new')
    @invite_attendance = Attendance.create!(event: @event2, invitee: @person, state: 'new')
  end
  scenario "User clicks on confirmed invite" do
    @new_attendance.update_attribute(:state, 'confirmed')
    visit "/invites/#{@new_attendance.code}"
    expect(page).to have_text("This invite has already been used.")
  end
  scenario "User clicks yes and has an invite to share" do
    visit "/invites/#{@new_attendance.code}"

    expect(page).to have_text("Hi Test. Thanks for cooking rostis with us")
    expect(page).to have_text("1st Feb")
    expect(page).to have_text("3PM - 5PM")
    click_button "Yes"

    expect(page).to have_text("Great!")

    reloaded_attendance = Attendance.find(@new_attendance.id)
    expect(reloaded_attendance.state).to eq('confirmed')
    expect(page).to have_text(invite_path(@invite_attendance.code))
  end

  scenario "User clicks yes and has no invite to share" do
    @invite_attendance.destroy!
    visit "/invites/#{@new_attendance.code}"

    expect(page).to have_text("Hi Test. Thanks for cooking rostis with us")
    expect(page).to have_text("1st Feb")
    expect(page).to have_text("3PM - 5PM")
    click_button "Yes"

    expect(page).to have_text("Great!")

    reloaded_attendance = Attendance.find(@new_attendance.id)
    expect(reloaded_attendance.state).to eq('confirmed')
  end

  scenario "User clicks no" do
    visit "/invites/#{@new_attendance.code}"

    expect(page).to have_text("Hi Test. Thanks for cooking rostis with us")
    expect(page).to have_text("1st Feb")
    expect(page).to have_text("3PM - 5PM")
    click_button "No"

    expect(page).to have_text("That's a shame")

    reloaded_attendance = Attendance.find(@new_attendance.id)
    expect(reloaded_attendance.state).to eq('rejected')
    reloaded_invite = Attendance.find(@invite_attendance.id)
    expect(reloaded_invite.state).to eq('inviter_rejected')
  end
end
