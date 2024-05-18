# frozen_string_literal: true

# Module to handle common resource CRUD operations
module ResourceOperations
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    def index
      message = "#{resource_model.underscore.humanize.pluralize} retrieved successfully"

      respond_to do |format|
        format.html
        format.json { api_success(:ok, message, collection_serializer(resources, serializer_constantize)) }
        format.js
      end
    end

    def new; end

    def create
      save_resource
    end

    def show
      message = "#{resource_model.underscore.humanize} retrieved successfully"

      respond_to do |format|
        format.html
        format.json { api_success(:ok, message, serializable_resource(resource, serializer_constantize)) }
        format.js
      end
    end

    def edit; end

    def update
      save_resource
    end

    def destroy
      resource.destroy
      message = "#{resource_model.underscore.humanize} has been destroy successfully"
      respond_to do |format|
        flash.now.alert = message
        format.html { redirect_to index_path }
        format.json { api_success(:ok, message, serializable_resource(resource, serializer_constantize)) }
        format.js
      end
    end

    private

    # Strong parameters for resource
    # Make sure PERMITTED_PARAMS is defined in your Model
    def resource_params
      params.require(resource_model.underscore).permit(resource_constantize::PERMITTED_PARAMS)
    end

    def save_resource
      resource_method, render_method = resource.new_record? ? ['Create', :new] : ['Update', :edit]
      if resource.save
        message = "#{resource_model.underscore.humanize} has been #{resource_method} successfully"

        respond_to do |format|
          flash.now.alert = message
          format.html { redirect_to resource }
          format.json { api_success(:ok, message, serializable_resource(resource, serializer_constantize)) }
          format.js
        end
      else
        respond_to do |format|
          format.html { render render_method }
          format.json { api_error(:unprocessable_entity, resource.errors) }
          format.js
        end
      end
    end

    def resource_constantize
      @resource_constantize ||= resource_model.constantize
    end

    def serializer_constantize
      @serializer_constantize ||= "#{resource_model}Serializer".constantize
    end

    def resources
      @resources ||= resource_constantize.all
    end

    def resource
      @resource ||= resource_constantize.find(params[:id])
    end

    # Assign resource attributes from params
    # We use this method for assigning attributes before the saving the resource
    def assign_resource_attributes
      resource.attributes = resource_params
    end

    def build_resource
      @resource = resource_constantize.new
    end

    def not_found
      api_error(:not_found, "Record not found with id='#{params[:id]}'")
    end

    def resource_model
      raise NotImplementedError
    end

    def index_path
      raise NotImplementedError
    end
  end
end
