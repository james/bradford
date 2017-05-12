class InvitesController < ApplicationController
  def redirect
    redirect_to invite_path(params[:code])
  end

  def show
    Attendance.find_by_code(params[:id]).viewed!
    if @attendance = Attendance.unconfirmed.find_by_code(params[:id])
      if @attendance.person# && @attendance.previous_event.present?
        render template: 'invites/return_invite'
      else
        if @attendance.person.blank?
          @attendance.person = Person.new
        end
        render template: 'invites/new_invite'
      end
    else
      render template: 'invites/used'
    end
  end

  def respond_to_return_invite
    @attendance = Attendance.find_by_code(params[:id])
    if attendance_params[:state] == 'confirmed'
      @attendance.confirm!
      send_confirmation_text(@attendance)
      if @attendance.shareable_invite
        redirect_to share_invite_path(@attendance.shareable_invite.code)
      else
        redirect_to confirmed_invite_path(@attendance.code)
      end
    else
      @attendance.reject!
      redirect_to rejected_invite_path(@attendance.code)
    end
  end

  def respond_to_new_invite
    @attendance = Attendance.find_by_code(params[:id])
    if attendance_params[:state] == 'confirmed'
      @attendance.update_attributes(attendance_params)
      @attendance.confirm!
      send_confirmation_text(@attendance)
      notify_inviter_accepted(@attendance)
      redirect_to confirmed_invite_path(@attendance.code)
    else
      @attendance.reject!
      notify_inviter_rejected(@attendance)
      redirect_to rejected_invite_path(@attendance.code)
    end
  end

  def share
    @attendance = Attendance.find_by_code(params[:id])
  end

  def rejected
    @attendance = Attendance.find_by_code(params[:id])
  end

  def confirmed
    @attendance = Attendance.find_by_code(params[:id])
  end

  # def update
  #   @attendance = Attendance.find_by_code(params[:id])
  #   @attendance.person = Person.new
  #   @attendance.update_attributes(attendance_params)
  #   redirect_to '/'
  # end

  private

  def attendance_params
    params.require(:attendance).permit(:state, person_attributes: [:name, :phone_number])
  end

  def send_confirmation_text(attendance)
    if ENV['TWILLIO_ID'] && Rails.env != 'test'
      @client = Twilio::REST::Client.new
      @client.messages.create(
        from: '+441133207067',
        to: attendance.person.phone_number,
        body: confirmation_message(attendance)
      )
    end
  end

  def confirmation_message(attendance)
    datetime = attendance.event.starts_at
    msg = "Hi #{attendance.person.first_name}. We look forward to seeing at the Local Welcome event. The details are:\n#{datetime.day}#{datetime.day.ordinal} #{datetime.strftime("%b")} #{datetime.strftime("%-I:%M%p")} - #{attendance.event.location}"
    if attendance.shareable_invite
      msg += "\n\nRemember you have a an invite to invite a friend. Just send them this link: #{short_invite_url(attendance.shareable_invite.code)}"
    end
    msg
  end

  def notify_inviter_accepted(attendance)
    if attendance.invitee && ENV['TWILLIO_ID'] && Rails.env != 'test'
      @client = Twilio::REST::Client.new
      @client.messages.create(
        from: '+441133207067',
        to: attendance.invitee.phone_number,
        body: "Good news! #{attendance.person.name} has accepted your invite to attend the Local Welcome event."
      )
    end
  end

  def notify_inviter_rejected(attendance)
    if attendance.invitee && ENV['TWILLIO_ID'] && Rails.env != 'test'
      @client = Twilio::REST::Client.new
      @client.messages.create(
        from: '+441133207067',
        to: attendance.invitee.phone_number,
        body: "Unfortunately your invite to attend the Local Welcome event was rejected by who you sent it to.\nDon't worry, you can still share your invite link with someone else:\n#{short_invite_url(attendance.code)}"
      )
    end
  end
end
