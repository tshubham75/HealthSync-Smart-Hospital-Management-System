class CreateAppointments < ActiveRecord::Migration[8.0]
  def change
    create_table :appointments do |t|
      t.references :slot, null: false, foreign_key: true
      t.references :patient_profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
