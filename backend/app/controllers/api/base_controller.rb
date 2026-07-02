module Api
  class BaseController < ApplicationController
    private

    def render_validation_errors(record)
      render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
