class Appointment < ApplicationRecord
  belongs_to :slot
  belongs_to :patient_profile
end
