# frozen_string_literal: true

module Webhooks
  class WebhooksController < ActionController::Base
    include BaseApi
    include ResourceOperations

    before_action :verify_access_token

    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    private

    def verify_access_token
      raise 'Please add HTTP_API_TOKEN in headers.' if request.headers['HTTP_API_TOKEN'].blank?
      raise 'Invalid api token.' unless request.headers['HTTP_API_TOKEN'] == ems_api_token
    rescue StandardError => e
      api_error(401, e.message)
    end
  end
end
