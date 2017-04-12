class Admin::AttendancesController < AdminController
  def new
    @attendance = Attendance.new(event_id: params[:event_id], person_id: params[:person_id])
    if @attendance.person.blank?
      @attendance.person = Person.new
    end
  end

  def create
    if params[:attendance][:person_id].present?
      params[:attendance][:person_attributes] = nil
    end
    @attendance = Attendance.create!(attendance_params)
    redirect_to admin_event_path(@attendance.event)
  end

  def edit
    @attendance = Attendance.find(params[:id])
  end

  def update
    @attendance = Attendance.find(params[:id])
    @attendance.update_attribute(:state, attendance_params[:state])
    redirect_to admin_event_path(@attendance.event)
  end

  def destroy
    @attendance = Attendance.find(params[:id])
    @event = @attendance.event
    @attendance.destroy!
    redirect_to admin_event_path(@event)
  end

  private
  def attendance_params
    params.require(:attendance).permit(:state, :invitee_id, :person_id, :event_id, person_attributes: [:name, :phone_number, :refugee])
  end
end
