class Admin::DepartmentsController < ApplicationController
  # before_action :authorize_admin!, only: [:index, :create, :new, :delete]

  def index
    @departments = Department.all
  end

  def new
    @department = Department.new
  end

  def create
    @department = Department.new(department_params)
    if @department.save
      redirect_to admin_departments_path, notice: "Department created"
    else
      render :new
    end
  end

  def error
    error = current_user
  end

  def edit
    @department = Department.find(params[:id])
  end

  def update
   @department = Department.find(params.dig(:id)).update(name: params[:department][:name], description: params[:department][:description])
    if @department
      redirect_to admin_departments_path, notice: "Department update sucessfully"
    else
      # flash[:warning] = @department.errors.full_messages}.join(", ")
      render :edit
    end
  end

def destroy
  @department = Department.find(params[:id])
      @department.destroy
      redirect_to admin_departments_path, notice: "Department was successfully deleted."
    end

  private

  def department_params
    params.require(:department).permit(:name, :description)
  end

  # def authorize_admin!
  #   if current_user.role == 'admin'
  #     return true
  #   else current_user.role == 'doctor' && current_user.role == 'patient'
  #     redirect_to admin_departments_path, alert: "Access denined. Admins only"
  #   end
  # end
end
