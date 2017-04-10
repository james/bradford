require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the InvitesHelper. For example:
#
# describe InvitesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  describe "two_hour_event_time" do
    it "should display 3PM - 5PM for 15:00" do
      str = two_hour_event_time("01/01/2018 15:00".to_time)
      expect(str).to eq("3PM - 5PM")
    end

    it "should display 3:30PM - 5:30PM for 15:30" do
      str = two_hour_event_time("01/01/2018 15:30".to_time)
      expect(str).to eq("3:30PM - 5:30PM")
    end
  end
end
