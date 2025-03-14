class DoctorMailer < ApplicationMailer
  def credentials_email(doctor, password)
    @doctor = doctor
    @password = password
    mail(to: @doctor.user.email, subject: "Your Hospital System Login Credentials")
  end
end
