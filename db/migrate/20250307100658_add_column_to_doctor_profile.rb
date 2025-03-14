class AddColumnToDoctorProfile < ActiveRecord::Migration[8.0]
  def change
    add_column :doctor_profiles, :email, :string
  end
end
