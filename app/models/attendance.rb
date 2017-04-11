class Attendance < ApplicationRecord
  belongs_to :event
  belongs_to :person, optional: true
  belongs_to :invitee, class_name: "Person", optional: true
  accepts_nested_attributes_for :person

  before_create :set_code

  scope :confirmed, -> { where(state: 'confirmed') }
  scope :unconfirmed, -> { where(state: 'new') }

  def set_code
    self.code = SecretSanta.create_code
  end

  def confirm!
    self.update_attribute(:state, 'confirmed')
  end

  def reject!
    self.update_attribute(:state, 'rejected')
    if self.shareable_invite
      self.shareable_invite.update_attribute(:state, 'inviter_rejected')
    end
  end

  def for_refugee?
    if person
      person.refugee?
    else
      invitee.refugee?
    end
  end

  def shareable_invites
    Attendance.where(event: self.event, invitee: self.person)
  end

  def shareable_invite
    shareable_invites.first
  end
end
