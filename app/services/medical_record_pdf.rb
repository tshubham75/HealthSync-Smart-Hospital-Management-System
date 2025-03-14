require "prawn"

class MedicalRecordPdf
  def initialize(patient_profile)
    @patient = patient_profile
    @consultations = @patient.consultations
  end

  def generate
    Prawn::Document.new do |pdf|
      pdf.text "Medical Record", size: 20, style: :bold
      pdf.move_down 10
      pdf.text "Patient Details", size: 15, style: :bold
      pdf.text "Name: #{@patient.first_name} #{@patient.middle_name} #{@patient.last_name}"
      pdf.text "DOB: #{@patient.date_of_birth}"
      pdf.text "Blood Group: #{@patient.blood_group}"
      pdf.text "Contact: #{@patient.contact_number}"
      pdf.text "Address: #{@patient.address}"
      pdf.move_down 20

      pdf.text "Consultations", size: 15, style: :bold
      @consultations.each do |consultation|
        pdf.move_down 10
        pdf.text "Doctor: #{consultation.doctor_profile.first_name} #{consultation.doctor_profile.last_name}", style: :bold
        pdf.text "Date: #{consultation.created_at.strftime('%d-%m-%Y')}"
        pdf.text "Condition: #{consultation.condition}"
        pdf.text "Medication: #{consultation.medication}"
        pdf.text "Comments: #{consultation.comments}"
        pdf.move_down 10
        pdf.stroke_horizontal_rule
      end

      pdf.render
    end
  end
end
