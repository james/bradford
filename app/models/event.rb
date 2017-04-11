class Event < ApplicationRecord
  has_many :attendances, dependent: :destroy
  has_many :people, through: :attendances
  default_scope { order(starts_at: 'ASC') }
end
