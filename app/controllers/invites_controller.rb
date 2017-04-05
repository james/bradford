class InvitesController < ApplicationController
  def show
    @attendance = Attendance.find_by_code(params[:id])
    @attendance.person = Person.new
  end

  def update
    @attendance = Attendance.find_by_code(params[:id])
    @attendance.person = Person.new
    @attendance.update_attributes(attendance_params)
    redirect_to '/'
  end

  private

  def attendance_params
    params.require(:attendance).permit(person_attributes: [:name, :phone_number])
  end
end
