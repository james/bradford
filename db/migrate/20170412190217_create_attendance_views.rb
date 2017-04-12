class CreateAttendanceViews < ActiveRecord::Migration[5.0]
  def change
    create_table :attendance_views do |t|
      t.references :attendance, foreign_key: true

      t.timestamps
    end
  end
end
