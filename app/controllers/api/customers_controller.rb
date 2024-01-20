# frozen_string_literal: true

module Api
  class CustomersController < ApplicationController
    def create
      customer = Customer.new(customer_params)

      if customer.save
        render json: { customer: customer }, status: :created
      else
        render json: { errors: customer.errors.full_messages },
               status: :unprocessable_entity
      end
    end

    private

    def customer_params
      params.require(:customer).permit(:name, :cpf, :date_of_birth)
    end
  end
end
