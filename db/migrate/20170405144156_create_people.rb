class CreatePeople < ActiveRecord::Migration[5.0]
  def change
    create_table :people do |t|
      t.boolean :refugee
      t.string :name
      t.string :phone_number

      t.timestamps
    end
  end
end
