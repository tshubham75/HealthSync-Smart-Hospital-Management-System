class AddDefaultToBedsStatus < ActiveRecord::Migration[8.0]
  def change
    change_column_default :beds, :status, 0
  end
end
