class Bed < ApplicationRecord
  belongs_to :room
  belongs_to :patient_profile, optional: true

  enum :status, { available: 0, occupied: 1 }, strict: false

  after_initialize :set_default_status, if: :new_record?

  private

  def set_default_status
    self.status ||= :available
  end
end
