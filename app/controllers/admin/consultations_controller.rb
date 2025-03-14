
class Admin::ConsultationsController < ApplicationController
  before_action :set_consultation, only: [ :show, :edit, :update, :destroy, :download_pdf, :recommend_admission ]
  before_action :authenticate_user!

  # List all consultations (for doctors)
  def index
    @consultations = Consultation.all
    # @consultations = current_user.doctor_profile.present? ? Consultation.all : Consultation.where(patient_profile_id: current_user.patient_profile.id)
  end

  # Show a single consultation
  def show
    @consultation = Consultation.find(params[:id])
   @assigned_bed = Bed.find_by(patient_profile_id: @consultation.patient_profile_id)
  @available_beds = Bed.where(patient_profile_id: nil).or(Bed.where(id: @assigned_bed&.id))
  end

  # Doctor Creates New Consultation
  def new
    @consultation = Consultation.new
  end

  # Doctor Saves Consultation
  def create
    @consultation = Consultation.new(consultation_params)
    if @consultation.save
      redirect_to admin_consultation_path(@consultation), notice: "Consultation record created successfully."
    else
      render :new
    end
  end

  # Doctor Edits Consultation
  def edit
  end

  # Doctor Updates Consultation
  def update
    if @consultation.update(consultation_params)
      redirect_to admin_consultations_path, notice: "Consultation updated successfully."
    else
      render :edit
    end
  end

  # Doctor Deletes Consultation
  def destroy
    @consultation.destroy
    redirect_to admin_consultations_path, notice: "Consultation deleted successfully."
  end

  # Generate PDF for consultation
  def download_pdf
    pdf = Prawn::Document.new
    pdf.text "Medical Record", size: 24, style: :bold
    pdf.move_down 10
    pdf.text "Patient: #{@consultation.patient_profile.first_name} #{@consultation.patient_profile.last_name}"
    pdf.text "Doctor: #{@consultation.doctor_profile.first_name} #{@consultation.doctor_profile.last_name}"
    pdf.text "Condition: #{@consultation.condition}"
    pdf.text "Medication: #{@consultation.medication}"
    pdf.text "Comments: #{@consultation.comments}"
    pdf.move_down 10
    pdf.text "Date: #{@consultation.created_at.strftime('%d-%m-%Y')}", style: :italic

    send_data pdf.render, filename: "Medical_Record_#{@consultation.id}.pdf", type: "application/pdf", disposition: "inline"
  end

  # Doctor Recommends Admission
  def recommend_admission
    @consultation.update(admission_required: true)
    redirect_to @consultation, notice: "Admission recommended successfully."
  end

  def toggle_bed_assignment
    @consultation = Consultation.find(params[:id])

  if params[:bed_id].present?
    # Assign new bed
    @assigned_bed = Bed.find(params[:bed_id])
    @assigned_bed.update(patient_profile_id: @consultation.patient_profile_id)
  else
    # Remove bed
    @assigned_bed = Bed.find_by(patient_profile_id: @consultation.patient_profile_id)
    @assigned_bed&.update(patient_profile_id: nil)
    @assigned_bed = nil  # Reset the variable
  end

  # Reload available beds (including the newly removed one)
  @available_beds = Bed.where(patient_profile_id: nil)

  respond_to do |format|
    format.html { redirect_to admin_consultation_path(@consultation) }
    format.js   # This will call toggle_bed_assignment.js.erb
  end
end




  private

  def set_consultation
    @consultation = Consultation.find(params[:id])
  end

  def consultation_params
    params.require(:consultation).permit(:doctor_profile_id, :patient_profile_id, :condition, :medication, :comments)
  end
end
