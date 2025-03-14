class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, {
    admin: "admin",
    doctor: "doctor",
    patient: "patient"
  }, default: "patient"

  has_many :doctor_profiles, dependent: :destroy
  has_many :patient_profiles, dependent: :destroy

  validates :role, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
end
