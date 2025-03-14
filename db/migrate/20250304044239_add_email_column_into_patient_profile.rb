class AddEmailColumnIntoPatientProfile < ActiveRecord::Migration[8.0]
  def change
    add_column :patient_profiles, :email, :string
  end
end
