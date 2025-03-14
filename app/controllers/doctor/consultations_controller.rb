class Doctor::ConsultationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_consultation, only: [ :show, :download ]

  def index
    @consultations = current_user.doctor_profile.consultations
  end

  def new
    @consultation = current_user.doctor_profile.consultations.new
    @consultation.build_patient_profile
  end

  def create
    @consultation = current_user.doctor_profile.consultations.new(consultation_params)
    if @consultation.save
      redirect_to doctor_consultation_path(@consultation), notice: "Consultation created"
    else
      render :new
    end
  end

  def download
    respond_to do |format|
      format.pdf do
        render pdf: "consultation_#{@consultation.id}",
               template: "doctor/consultations/download",
               layout: "pdf.html",
               formats: [ :html ]
      end
    end
  end

  private

  def set_consultation
    @consultation = current_user.doctor_profile.consultations.find(params[:id])
  end

  def consultation_params
    params.require(:consultation).permit(
      :comments, :condition, :medication,
      patient_profile_attributes: [ :first_name, :last_name, :date_of_birth, :contact_number, :gender, :blood_group ],
      documents: []
    )
  end
end
