class ChangePatientProfileIdInBeds < ActiveRecord::Migration[8.0]
  def change
    change_column_null :beds, :patient_profile_id, true  # Allow NULL values
  end
end
