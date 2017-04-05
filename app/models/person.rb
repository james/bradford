class Person < ApplicationRecord
  has_many :attendances
  has_many :events, through: :attendances
  has_many :invitees, class_name: "Attendance"

  def self.inheritance_column
    'something_else'
  end
end
