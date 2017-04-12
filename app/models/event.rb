class Event < ApplicationRecord
  has_many :attendances, dependent: :destroy
  has_many :people, through: :attendances
  default_scope { order(starts_at: 'ASC') }
  scope :past, -> { where("starts_at < ?", Time.now) }
  scope :future, -> { where("starts_at > ?", Time.now) }
end
