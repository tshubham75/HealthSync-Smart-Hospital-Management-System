class CreateBeds < ActiveRecord::Migration[8.0]
  def change
    create_table :beds do |t|
      t.references :room, null: false, foreign_key: true
      t.string :bed_number
      t.integer :status
      t.references :patient_profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
