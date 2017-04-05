class Person < ApplicationRecord
  has_many :attendances
  has_many :events, through: :attendances
  has_many :invitees, class_name: "Attendance", foreign_key: 'invitee_id'

  def self.inheritance_column
    'something_else'
  end
end
