class SlotPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user.patient?
        scope.where(patient_profiles_id: user.patient_profile.id)
      elsif user.doctor?
        scope.where(doctor_profile_id: user.doctor_profile.id)
      else
        scope.none
      end
    end
  end

  def index?
    user.admin? || user.patient? || user.doctor?
  end

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

  def edit?
    user.admin?
  end

  def update?
    user.admin?
  end

  def book?
    user.admin? || user.patient?
  end
end
