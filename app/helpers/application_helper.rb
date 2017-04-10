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
end
