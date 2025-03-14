class Consultation < ApplicationRecord
  belongs_to :doctor_profile
  belongs_to :patient_profile
  has_many_attached :documents
  validates :documents, content_type: [ "application/pdf", "image/jpeg", "image/png" ]
end
