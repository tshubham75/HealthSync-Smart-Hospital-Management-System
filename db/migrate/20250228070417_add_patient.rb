class AddPatient < ActiveRecord::Migration[8.0]
  def change
    add_reference :slots, :patient_profiles, null: false, foreign_key: true
  end
end
