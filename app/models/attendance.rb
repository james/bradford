class Attendance < ApplicationRecord
  belongs_to :event
  belongs_to :person, optional: true
  belongs_to :invitee, class_name: "Person", optional: true
  accepts_nested_attributes_for :person

  before_create :set_code

  def set_code
    self.code = SecretSanta.create_code
  end

  def confirm!
    self.update_attribute(:state, 'confirmed')
  end

  def create_invite!
    Attendance.create!(event: self.event, invitee: self.person)
  end

  def reject!
    self.update_attribute(:state, 'rejected')
  end

  def shareable_invites
    Attendance.where(event: self.event, invitee: self.person)
  end
end
