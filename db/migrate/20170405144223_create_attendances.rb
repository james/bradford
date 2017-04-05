class CreateAttendances < ActiveRecord::Migration[5.0]
  def change
    create_table :attendances do |t|
      t.references :event, foreign_key: true
      t.references :person, foreign_key: true
      t.string :code
      t.string :state
      t.integer :invitee_id

      t.timestamps
    end
  end
end
