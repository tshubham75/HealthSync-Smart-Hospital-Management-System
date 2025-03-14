require "csv"
require "prawn"

class Admin::DoctorProfilesController < ApplicationController
  before_action :authorize_admin, only: [ :index, :create, :new, :destroy ]

  def index
    @doctor_profiles = DoctorProfile.all
  end

  def show
    @doctor_profile = DoctorProfile.find_by(user_id: params[:id])
  end

  def new
    @doctor_profile = DoctorProfile.new
  end

  def create
    password = Devise.friendly_token.first(12)

    email = params.dig(:doctor_profile, :email) || params.dig(:user, :email)
    name = [ params.dig(:doctor_profile, :first_name), params.dig(:doctor_profile, :last_name) ].compact.join(" ")

    @user = User.new(
      role: :doctor,
      email: email,
      password: password,
      password_confirmation: password,
      name: name
      )

    if @user.save
      @doctor_profile = @user.doctor_profiles.create(doctor_profile_params.merge(user_id: @user.id))

      if @doctor_profile.save
        DoctorMailer.credentials_email(@user, password).deliver_later
        redirect_to admin_doctor_profiles_path, notice: "Doctor created successfully"
      else
        flash[:alert] = @doctor_profile.errors.full_messages.join(", ")
        render :new, status: :unprocessable_entity
      end
    else
      flash[:alert] = @user.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end



  def edit
    @doctor_profile = DoctorProfile.find(params[:id])
  # @doctor_profile = DoctorProfile.find_by(user_id:params[:id])
end

def update
  @doctor_profile = DoctorProfile.find(params[:id])
  if @doctor_profile.update(doctor_profile_params)
    redirect_to admin_doctor_profile_path(@doctor_profile), notice: "Doctor updated successfully."
  else
    flash[:alert] = @doctor_profile.errors.full_messages.join(", ")
    render :edit, status: :unprocessable_entity
  end
end

def destroy
  @doctor_profile =  DoctorProfile.find(params[:"id"])
  @doctor_profile.delete
  redirect_to admin_doctor_profiles_path, notice: "Doctor deleted successfully."
end

def see_patients
  @slots = Slot.where(doctor_profile_id: params[:doctor_id])
end

  # ------------------------------------

  def dashboard
    @patients = PatientProfile.joins(:consultations)
    .where(consultations: { doctor_profile_id: current_user.doctor_profiles.first.id })
    .distinct
  end

  # Download specific patient's consultations as CSV
  def download_patient_csv
    consultations = Consultation.where(doctor_profile_id: current_user.doctor_profiles.first.id, patient_profile_id: params[:id])

    csv_data = CSV.generate(headers: true) do |csv|
      csv << [ "Patient Name", "Condition", "Medication", "Comments", "Date" ]

      consultations.each do |consultation|
        csv << [
          consultation.patient_profile.full_name,
          consultation.condition,
          consultation.medication,
          consultation.comments,
          consultation.created_at.strftime("%d-%m-%Y %H:%M")
        ]
      end
    end

    send_data csv_data, filename: "consultation_#{params[:id]}_#{Date.today}.csv", type: "text/csv"
  end

  # Download specific patient's consultations as PDF
  def download_patient_pdf
  consultation = Consultation.find(params[:id])
  pdf = Prawn::Document.new(page_size: "A4", margin: 50)

  # Header - Hospital Name
  pdf.text "Shubham Multispecialty Hospital", size: 24, style: :bold, align: :center
  pdf.move_down 5
  pdf.text "Consultation Report", size: 20, style: :bold, align: :center
  pdf.stroke_horizontal_rule
  pdf.move_down 15  # Space below the header

  # Doctor Info
  pdf.text "Doctor Information", size: 14, style: :bold, color: "0056A7"
  pdf.stroke_horizontal_rule
  pdf.move_down 10
  pdf.text "Dr. #{consultation.doctor_profile.slice(:first_name, :middle_name, :last_name).values.join(" ")}", size: 12
  pdf.move_down 15  # Space before next section

  # Patient Info
  pdf.text "Patient Information", size: 14, style: :bold, color: "0056A7"
  pdf.stroke_horizontal_rule
  pdf.move_down 10
  pdf.text "#{consultation.patient_profile.slice(:first_name, :middle_name, :last_name).values.join(" ")}", size: 12
  pdf.move_down 15  # Space before next section

  # Medical Details Section
  pdf.text "Medical Details", size: 14, style: :bold, color: "0056A7"
  pdf.stroke_horizontal_rule
  pdf.move_down 10  # Add space before Condition

  # Condition Section
  pdf.text "Condition:", size: 12, style: :bold
  pdf.move_down 5
  consultation.condition.split(". ").each do |line|
    pdf.text "#{line.strip}", size: 12
  end
  pdf.move_down 10  # Space before Medication

  # Medication Section
  pdf.text "Medication:", size: 12, style: :bold
  pdf.move_down 5
  consultation.medication.split(". ").each do |line|
    pdf.text "#{line.strip}", size: 12
  end
  pdf.move_down 10  # Space before Comments

  # Comments Section
  pdf.text "Comments:", size: 12, style: :bold
  pdf.move_down 5
  consultation.comments.split(". ").each do |line|
    pdf.text "#{line.strip}", size: 12
  end
  pdf.move_down 10  # Space before Consultation Date

  # Consultation Date
  pdf.text "Consultation Date: #{consultation.created_at.strftime("%d-%m-%Y %H:%M")}", size: 12, style: :italic
  pdf.move_down 20  # Space before footer

  # Footer - Signature
  pdf.stroke_horizontal_rule
  pdf.move_down 20
  pdf.text "Authorized Signature:", size: 12, align: :right
  pdf.move_down 40
  pdf.text "________________________", align: :right
  pdf.text "Dr. #{consultation.doctor_profile.slice(:first_name, :middle_name, :last_name).values.join(" ")}", size: 12, align: :right
  pdf.text "Shubham Multispecialty Hospital", size: 10, align: :right
  pdf.move_down 10
  pdf.stroke_horizontal_rule
  pdf.text "This is a computer-generated report. No signature required.", size: 8, align: :center, color: "888888"

  send_data pdf.render, filename: "consultation_#{params[:id]}_#{Date.today}.pdf", type: "application/pdf"
end


  # ------------------------------------

  private

  def set_doctor_profile
    @doctor_profile = DoctorProfile.find(params[:id])
  end

  def doctor_profile_params
    params.require(:doctor_profile).permit(
      :first_name, :middle_name, :last_name,
      :date_of_birth, :contact_number,
      :nationality, :gender, :qualifications,
      :experience, :email, :department_id
      ).merge(creator_id: current_user.id, updator_id: current_user.id)
  end

  def authorize_admin
        return if current_user&.role == "admin" # Admin has full access

        if current_user&.role == "doctor"
          doctor = DoctorProfile.find_by(user_id: current_user.id)
          unless params[:action].in?([ "edit", "update" ])
            redirect_to admin_doctor_profile_path(doctor), alert: "You are not authorized to access this page."
          end
        else
          redirect_to root_path, alert: "You are not authorized to access this page."
        end
      end
end
