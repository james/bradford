module ApplicationHelper
  def friendly_date(datetime)
    "#{datetime.day}#{datetime.day.ordinal} #{datetime.strftime("%b")}"
  end

  def two_hour_event_time(datetime)
    endtime = datetime + 2.hours
    if datetime.min == 0
      "#{datetime.strftime("%-I%p")} - #{endtime.strftime("%-I%p")}"
    else
      "#{datetime.strftime("%-I:%M%p")} - #{endtime.strftime("%-I:%M%p")}"
    end
  end

  def lw_time_ago_in_words(datetime, time_now=Time.now)
    days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    time_ago_in_days = (time_now - datetime) / 1.day
    if time_ago_in_days < 7
      "last #{days[datetime.day]}"
    elsif time_ago_in_days >= 7 && time_ago_in_days < 14
      "last week"
    else
      "#{(time_ago_in_days/7).to_i} weeks ago"
    end
  end

  def lw_time_until_in_words(datetime, time_now=Time.now)
    days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    time_until_in_days = (datetime - time_now) / 1.day
    if time_until_in_days < 7
      "on #{days[datetime.day]}"
    elsif time_until_in_days >= 7 && time_until_in_days <= 15
      "in #{time_until_in_days.to_i} days"
    else
      "in #{(time_until_in_days/7).to_i} weeks"
    end
  end
end
