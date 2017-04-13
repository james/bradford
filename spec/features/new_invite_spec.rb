require "rails_helper"

RSpec.feature "New user is invited", :type => :feature do
  before do
    @event = Event.create!(name: "Test Event 1", starts_at: "01/01/2018 15:30".to_time)
    @inviter = Person.create!(name: "Test Inviter", phone_number: "012345")
    @inviter_attendance = Attendance.create!(event: @event, person: @inviter, state: 'confirmed')
    @attendance = Attendance.create!(event: @event, invitee: @inviter, state: 'new')
  end
  scenario "User clicks on confirmed invite" do
    @attendance.update_attribute(:state, 'confirmed')
    visit "/invites/#{@attendance.code}"
    expect(page).to have_text("This invite has already been used.")
    expect(@attendance.view_count).to eq(1)
  end

  scenario "User clicks yes when invited by a friend" do
    visit "/invites/#{@attendance.code}"

    expect(page).to have_text("Test Inviter is attending a Local Welcome event")
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

    expect(@attendance.view_count).to eq(1)
  end

  scenario "User clicks yes when invited by us" do
    @inviter.destroy!
    visit "/invites/#{@attendance.code}"

    expect(page).to have_text("You are invited to a Local Welcome event")
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

    expect(@attendance.view_count).to eq(1)
  end

  scenario "User clicks no" do
    visit "/invites/#{@attendance.code}"

    expect(page).to have_text("Test Inviter is attending a Local Welcome event")
    expect(page).to have_text("1st Jan")
    expect(page).to have_text("3:30PM - 5:30PM")
    click_button "I can't come"

    expect(page).to have_text("That's a shame")
    reloaded_attendance = Attendance.find(@attendance.id)
    expect(reloaded_attendance.state).to eq('rejected')

    inviter_attendance = Attendance.find(@inviter_attendance.id)
    expect(inviter_attendance.state).to eq('confirmed')

    expect(@attendance.view_count).to eq(1)
  end
end
