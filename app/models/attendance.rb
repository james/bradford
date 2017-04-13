class Attendance < ApplicationRecord
  belongs_to :event
  belongs_to :person, optional: true
  belongs_to :invitee, class_name: "Person", optional: true
  has_many :attendance_views
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

  def seats_left
    if for_refugee?
      4 - event.people.refugees.count
    else
      4 - event.people.volunteers.count
    end
  end

  def shareable_invites
    if self.person
      Attendance.where(event: self.event, invitee: self.person)
    else
      []
    end
  end

  def shareable_invite
    shareable_invites.first
  end

  def previous_event
    person.events.past.order("starts_at DESC").first
  end

  def view_count
    attendance_views.count
  end

  def viewed!
    attendance_views.create!
  end
end
