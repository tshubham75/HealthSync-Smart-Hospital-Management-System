require "securerandom"
require "csv"
require "prawn"
require "prawn/table"

class PatientsController < ApplicationController
  before_action :authorize_patient, only: %i[show edit update book]


  def index
    @patients = PatientProfile.all
  end

  def show
    @patient = PatientProfile.find_by(user_id: params[:id])
  if params[:called_from_authorization].present?
    @patient = PatientProfile.find(params[:id])
  else
    @patient = PatientProfile.find_by(user_id: current_user.id)
  end

  if @patient.nil?
    redirect_to root_path, alert: "Patient record not found!"
  end
end

def new
  @patient = PatientProfile.new
end

def create
  create_user_for_patie nt if current_user&.role == "admin"
  @patient = PatientProfile.new(patient_params)
  if @user&.save || current_user&.role == "patient"
    @patient
    # @patient.update!(user_id: current_user.id) if current_user&.role == 'admin'
    @patient.update!(user_id: current_user.id) if current_user&.role.in? [ "patient", "admin" ]
    if @patient.save
      if current_user&.role == "patient"
      redirect_to patient_path(@patient), notice: "Patient profile created successfully."
      elsif current_user&.role == "admin"
      redirect_to patients_path, notice: "Patient profile created successfully."
      else
      end
    else
      render :new, status: :unprocessable_entity
    end
  else
    render :new, status: "User cannot save due to #{@user.errors.full_messages}"
  end
end

def edit
  @patient = PatientProfile.find(params[:id])
end

def update
  @patient = PatientProfile.find(params[:id])
  if @patient.update(patient_params)
    redirect_to patient_path(@patient), notice: "Patient profile updated successfully."
  else
    render :edit, status: :unprocessable_entity
  end
end

def destroy
  @patient.destroy
  redirect_to patients_path, notice: "Patient profile deleted successfully."
end

def booking_appointment
  @slots = Slot.left_outer_joins(:appointment).where(appointments: { id: nil })
end

def book
  @slot = Slot.find(params[:slot_id])
  @appointment = Appointment.new(slot: @slot, patient_profile_id: params[:patient_id])

  if @appointment.save
    redirect_to patient_path(params[:patient_id]), notice: "Appointment booked successfully!"
  else
    redirect_to booking_appointment_path, alert: "Failed to book appointment."
  end
end

#--------------------------------

def download_consultations
  patient_profile = current_user.patient_profiles.first
  consultations = Consultation.where(patient_profile_id: patient_profile.id)

  if params[:format] == "pdf"
    pdf = Prawn::Document.new
    pdf.text "Consultation Records", size: 20, style: :bold
    pdf.move_down 10

    if consultations.empty?
      pdf.text "No consultation records found.", size: 14, style: :italic
    else
      consultations.each do |consultation|
        pdf.text "Date: #{consultation.date}"
        pdf.text "Doctor: #{consultation.doctor_name}"
        pdf.text "Notes: #{consultation.notes}"
        pdf.move_down 10
      end
    end

    send_data pdf.render, filename: "consultations.pdf", type: "application/pdf", disposition: "inline"

  elsif params[:format] == "csv"
    csv_data = CSV.generate(headers: true) do |csv|
      csv << [ "Date", "Doctor", "Notes" ]

      if consultations.empty?
        csv << [ "No consultation records found.", "", "" ]
      else
        consultations.each do |consultation|
          csv << [ consultation.date, consultation.doctor_name, consultation.notes ]
        end
      end
    end

    send_data csv_data, filename: "consultations.csv", type: "text/csv"
  else
    redirect_to consultations_path, alert: "Invalid format selected."
  end
end


# -------------------------------

private

  def patient_params
    params.require(:patient_profile).permit(:first_name, :middle_name, :last_name, :date_of_birth, :address, :contact_number, :gender, :blood_group, :email, :photo)
  end

  def create_user_for_patient
    email = params[:patient_profile].dig(:email)

  if !email.present?
    first_name = params[:patient_profile].values_at(:first_name)
    last_name  = params[:patient_profile].values_at(:last_name)
    email = "#{first_name.downcase}.#{last_name.downcase}.#{SecureRandom.hex(3)}@gmail.com"
  end

  name = params[:patient_profile].values_at(:first_name, :middle_name, :last_name).join(" ")
  password = 123456

    # @user = User.new(role: :doctor,email: email ,password: password, password_confirmation: password, name: name)

    @user = User.new(name: name, role: :patient, email: email, password: password, password_confirmation: password)
  end

  def authorize_patient
    unless current_user.role == "patient"
      redirect_to root_path, alert: "Access denied!"
    end
  end
end
