class SlotsController < ApplicationController
  before_action :admin_access_only

  def index
    @available_slots = Slot.includes(:doctor_profile)
  end

  def new
    @slot = Slot.new
  end

  def create
    @slot = Slot.new(params_for_slots)  # Use `Slot.new` instead of `@slot.new`
    if @slot.save
      redirect_to slots_index_path, notice: "Slot created successfully"  # Use `notice` instead of `alert`
    else
      render :new  # `new` should be a symbol (:new) to render the correct template
    end
  end

  def edit
    @slot = Slot.find(params[:id])
  end

  def update
    @slot = Slot.find(params[:id])
    if @slot.update!(params_for_slots)
      redirect_to slots_index_path, notice: "successfully book slot for patient"
    else
      redirect_to edit_slot_path(@slot), alert: "unprocessable_entity "
    end
  end

  def book
    @slot = Slot.find(params[:id])
    if current_user&.role.in? [ "admin", "patient" ]
      if @slot.patient_profiles_id.nil?
        if @slot.end_time.nil?
          @slot.end_time = Time.now.strftime("%d/%m/%Y %H:%M")
        end
        patient_profile = PatientProfile.find_by(user_id: current_user.id)
      @slot.update(patient_profiles_id: patient_profile.id) # Assuming current_patient is set
      redirect_to slots_path, notice: "Slot booked successfully!"
      else
      if current_user.role.in? [ "admin", "doctor" ]
        doctor = DoctorProfile.find(@slot.doctor_profile_id)
        doctor_name = [ doctor.first_name, doctor.middle_name, doctor.last_name ].compact.join(" ")

        formatted_start_time = @slot.start_time.to_datetime.strftime("%Y-%m-%d %H:%M")
        if @slot.end_time.present?
          formatted_end_time = Time.at(@slot.end_time).strftime("%Y-%m-%d %H:%M")
        else
          formatted_end_time = "End time not decided yet"
        end

        patient = PatientProfile.find_by(id: @slot.patient_profiles_id)
        patient_name = [ doctor.first_name, doctor.middle_name, doctor.last_name ].compact.join(" ")
        redirect_to slots_path, alert: "Slot already booked. by patient #{patient_name} for doctor #{doctor_name} from #{formatted_start_time} to #{formatted_end_time}"
      else
        redirect_to slots_path, alert: "Slot already booked."
      end
      end
    else
    render :new, status: :unprocessable_entity
    end
end

private

def params_for_slots
  params.require(:slot).permit(:doctor_profile_id, :start_time, :end_time, :patient_profiles_id)
  .merge(user_id: current_user.id, patient_profiles_id: params[:slot][:patient_profiles_id].presence,
   end_time: params[:slot][:end_time])
end

def admin_access_only
        return if current_user&.role == "admin"  # Only admins can proceed

        if current_user&.role == "patient"
          redirect_to patient_path(current_user), alert: "Access denied."
        elsif current_user&.role == "doctor"
          redirect_to admin_doctor_path(current_user), alert: "Access denied."
        else
          redirect_to destroy_user_session_path, alert: "Access denied."
        end
      end
end
