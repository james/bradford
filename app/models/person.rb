class Person < ApplicationRecord
  has_many :attendances, dependent: :destroy
  has_many :events, through: :attendances
  has_many :invitees, class_name: "Attendance", foreign_key: 'invitee_id'

  validates :name, presence: true
  validates :phone_number, presence: true
end
