class Slot < ApplicationRecord
  has_one :appointment
  belongs_to :doctor_profile
  belongs_to :patient_profile, optional: true
end
