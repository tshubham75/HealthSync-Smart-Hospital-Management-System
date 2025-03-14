class PatientNullCanBeTrue < ActiveRecord::Migration[8.0]
  def change
    change_column_null :patient_profiles, :user_id, true
  end
end
