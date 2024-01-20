# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActionController::ParameterMissing, with: :four_zero_zero
    rescue_from ActionDispatch::Http::Parameters::ParseError, with: :four_twenty_two
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from ActiveRecord::RecordNotUnique, with: :four_zero_nine

    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { errors: e.message }, status: :not_found
    end
  end

  private

  # JSON response with message; Status code 422 - unprocessable entity
  def four_twenty_two(err)
    render json: { errors: err.message }, status: :unprocessable_entity
  end

  # JSON response with message; Status code 400 - Bad request
  def four_zero_zero(err)
    render json: { errors: err.message }, status: :bad_request
  end

  # JSON response with message; Status code 409 - Conflict
  def four_zero_nine(err)
    render json: { errors: err.message }, status: :conflict
  end
end
