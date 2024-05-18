# frozen_string_literal: true

# Module to handle common API functionalities
module BaseApi
  extend ActiveSupport::Concern

  included do
    # Method to render JSON error response
    def api_error(status = 500, errors = [])
      render json: { data: {}, type: 'Error', status:, message: errors }, status:
    end

    # Method to render JSON success response
    def api_success(status = 200, message = [], data = {})
      render json: { type: 'Success', status:, message:, data: }, status:
    end

    # Method to serialize a collection using a serializer
    def collection_serializer(collection, serializer)
      ActiveModel::Serializer::CollectionSerializer.new(collection, serializer:)
    end

    # Method to serialize a single resource using a serializer
    def serializable_resource(collection, serializer)
      ActiveModelSerializers::SerializableResource.new(collection, serializer:)
    end

    private

    # Method to retrieve the API token for the Galaxy system from Rails credentials
    def ems_api_token
      Rails.application.credentials.dig(Rails.env, :ems, :api_token) || 'TOKEN'
    end
  end
end
