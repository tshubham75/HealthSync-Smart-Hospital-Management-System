class DoctorProfile < ApplicationRecord
  belongs_to :user
  has_many :slots
  belongs_to :department
end
