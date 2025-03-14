class ChangeDataTypeOfSlot < ActiveRecord::Migration[8.0]
  def change
    remove_column :slots, :end_time, :integer  # Correct syntax
    add_column :slots, :end_time, :datetime
  end
end
