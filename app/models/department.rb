class Department < ApplicationRecord
  has_many :rooms
  has_many :doctor_profiles
end
