class CreateRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :rooms do |t|
      t.references :department, null: false, foreign_key: true
      t.string :room_number

      t.timestamps
    end
  end
end
