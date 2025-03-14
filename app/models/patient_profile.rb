class PatientProfile < ApplicationRecord
  belongs_to :user
  has_one_attached :photo
  has_many :appointments
  has_many :consultations
end
