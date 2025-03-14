class CreateDoctorProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :doctor_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.date :date_of_birth
      t.string :contact_number
      t.string :nationality
      t.string :gender
      t.text :qualifications
      t.text :experience

      t.timestamps
    end
  end
end
