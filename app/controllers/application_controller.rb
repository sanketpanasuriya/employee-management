class ApplicationController < ActionController::Base
  include BaseApi
  include ResourceOperations

  private

  def not_found
    redirect_back fallback_location: root_path, notice: "Record not found with id='#{params[:id]}'"
  end
end
