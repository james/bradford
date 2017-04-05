class Attendance < ApplicationRecord
  belongs_to :event
  belongs_to :person
  belongs_to :invitee, class_name: "Person", optional: true
end
