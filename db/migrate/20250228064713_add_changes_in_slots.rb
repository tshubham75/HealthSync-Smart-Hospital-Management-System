class AddChangesInSlots < ActiveRecord::Migration[8.0]
  def change
    add_reference :slots, :user, foreign_key: true

    rename_column :slots, :duration, :end_time

    # change_column :slots, :end_time, 'timestamp without time zone USING end_time::timestamp without time zone', null: false
  end
end
