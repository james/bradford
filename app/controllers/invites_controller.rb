class InvitesController < ApplicationController
  def show
    @attendance = Attendance.find_by_code(params[:id])
    if @attendance.person && @attendance.previous_event.present?
      render template: 'invites/return_invite'
    else
      if @attendance.person.blank?
        @attendance.person = Person.new
      end
      render template: 'invites/new_invite'
    end
  end

  def respond_to_return_invite
    @attendance = Attendance.find_by_code(params[:id])
    if attendance_params[:state] == 'confirmed'
      @attendance.confirm!
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
      redirect_to confirmed_invite_path(@attendance.code)
    else
      @attendance.reject!
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
end
