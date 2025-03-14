class HomeController < ApplicationController
  def index
    return redirect_to new_user_session_path, alert: "You must sign in first." unless user_signed_in?

  case current_user.role
  when "admin"
    flash[:notice] = "Welcome admin!"
  when "doctor"
    redirect_to admin_doctor_profile_path(current_user.id), alert: "You are not authorized to access this page." and return
  when "patient"
    if PatientProfile.find_by(user_id: current_user.id)&.user_id == current_user.id
      name = PatientProfile.find(current_user.id).attributes.values_at("first_name", "middle_n
ame", "last_name").join(" ")
      redirect_to patient_path(current_user.id), alert: "welcome #{name}"
    else
    redirect_to new_patient_path, alert: "Hello, patient!" and return
    end
  else
    redirect_to destroy_user_session_path, notice: "Signed out successfully." and return
  end
end
end
