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

  describe "lw_time_ago_in_words" do
    it "should say 'last weekday' if less than a week ago" do
      str = lw_time_ago_in_words("01/01/2018 12:00".to_time, "06/01/2018 12:00".to_time)
      expect(str).to eq("last Monday")
    end
    it "should say 'last week' if between 7 and 14 days ago" do
      str = lw_time_ago_in_words("01/01/2018 12:00".to_time, "09/01/2018 12:00".to_time)
      expect(str).to eq("last week")
    end
    it "should say 'x weeks ago' if 2 or more weeks ago" do
      str = lw_time_ago_in_words("01/01/2018 12:00".to_time, "16/01/2018 12:00".to_time)
      expect(str).to eq("2 weeks ago")
    end
  end

  describe "lw_time_until_in_words" do
    it "should say 'on weekday' if  in less than a week" do
      str = lw_time_until_in_words("01/01/2018 12:00".to_time, "26/12/2017 12:00".to_time)
      expect(str).to eq("on Monday")
    end
    it "should say 'in x days' if in 7 to 15 days" do
      str = lw_time_until_in_words("01/01/2018 12:00".to_time, "20/12/2017 12:00".to_time)
      expect(str).to eq("in 12 days")
    end
    it "should say 'x weeks ago' if 2 or more weeks ago" do
      str = lw_time_until_in_words("01/01/2018 12:00".to_time, "16/12/2017 12:00".to_time)
      expect(str).to eq("in 2 weeks")
    end
  end
end
