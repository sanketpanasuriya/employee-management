# frozen_string_literal: true

module Webhooks
  class EmployeesController < WebhooksController
    before_action :build_resource, only: %i[create]
    before_action :resource, only: %i[update show destroy]
    before_action :assign_resource_attributes, only: %i[create update]

    private

    def resource_model
      'Employee'
    end
  end
end
