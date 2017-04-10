class MakeAttendanceStateDefault < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:attendances, :state, 'new')
  end
end
