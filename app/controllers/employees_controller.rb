class EmployeesController < ApplicationController
  before_action :resources, only: %i[index]
  before_action :build_resource, only: %i[new create]
  before_action :resource, only: %i[edit update show destroy]
  before_action :assign_resource_attributes, only: %i[create update]

  def fetch_third_party_employees
    ThirdPartyEmployeeJob.perform_async
    redirect_to employees_path, notice: 'Sync with third-party initiated.'
  end

  private

  def resource_model
    'Employee'
  end

  def index_path
    employees_path
  end
end
