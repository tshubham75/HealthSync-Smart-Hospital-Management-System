class AddReferenceOfUserToRooms < ActiveRecord::Migration[8.0]
  def change
    add_reference :rooms, :user, foreign_key: true
  end
end
