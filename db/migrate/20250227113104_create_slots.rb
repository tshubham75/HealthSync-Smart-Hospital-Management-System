class CreateSlots < ActiveRecord::Migration[8.0]
  def change
    create_table :slots do |t|
      t.references :doctor_profile, null: false, foreign_key: true
      t.datetime :start_time
      t.integer :duration

      t.timestamps
    end
  end
end
