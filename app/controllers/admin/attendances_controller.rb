class Admin::AttendancesController < ApplicationController
  def create
    def create
      @attendance = Attendance.create!(attendance_params)
      redirect_to person_path(@attendance.invitee)
    end
  end

  private
  def attendance_params
    params.require(:attendance).permit(:invitee_id, :event_id)
  end
end
