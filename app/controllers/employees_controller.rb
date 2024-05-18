class EmployeesController < ApplicationController
  before_action :resources, only: %i[index]
  before_action :build_resource, only: %i[new create]
  before_action :resource, only: %i[edit update show destroy]
  before_action :assign_resource_attributes, only: %i[create update]

  private

  def resource_model
    'Employee'
  end

  def index_path
    employees_path
  end
end
