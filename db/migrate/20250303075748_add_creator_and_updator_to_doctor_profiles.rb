class AddCreatorAndUpdatorToDoctorProfiles < ActiveRecord::Migration[8.0]
  def change
    add_column :doctor_profiles, :creator_id, :integer
    add_column :doctor_profiles, :updator_id, :integer
  end
end
