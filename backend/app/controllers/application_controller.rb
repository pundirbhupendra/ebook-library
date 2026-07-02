class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActionController::ParameterMissing, with: :render_parameter_missing

  private

  def render_not_found
    render json: { error: "Ebook not found" }, status: :not_found
  end

  def render_parameter_missing(error)
    render json: { error: error.message }, status: :bad_request
  end
end
