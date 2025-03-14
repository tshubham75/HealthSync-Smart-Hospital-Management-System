class ChangePatientProfilesIdInSlots < ActiveRecord::Migration[8.0]
  def change
    change_column_null :slots, :patient_profiles_id, true
  end
end
