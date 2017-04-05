class Attendance < ApplicationRecord
  belongs_to :event
  belongs_to :person, optional: true
  belongs_to :invitee, class_name: "Person", optional: true

  before_create :set_code

  def set_code
    self.code = SecretSanta.create_code
  end
end
