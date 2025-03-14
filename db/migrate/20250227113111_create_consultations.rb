class CreateConsultations < ActiveRecord::Migration[8.0]
  def change
    create_table :consultations do |t|
      t.references :doctor_profile, null: false, foreign_key: true
      t.references :patient_profile, null: false, foreign_key: true
      t.text :comments
      t.text :condition
      t.text :medication

      t.timestamps
    end
  end
end
