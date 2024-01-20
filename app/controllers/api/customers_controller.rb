# frozen_string_literal: true

module Api
  class CustomersController < ApplicationController
    def index
      if cpf_number
        search_customer_by_cpf
      else
        list_customers
      end
    end

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

    def cpf_number
      return if params[:cpf].nil?

      @cpf_number || params[:cpf].gsub(/\D/, '')
    end

    def search_customer_by_cpf
      if CpfValidator.valid?(cpf_number)
        customer = Customer.find_by(cpf: cpf_number)

        customer ? render_customer(customer) : render_not_found
      else
        render_invalid_cpf
      end
    end

    def render_customer(customer)
      render json: { customer: customer }, status: :ok
    end

    def render_not_found
      render json: { error: 'Customer not found' }, status: :not_found
    end

    def render_invalid_cpf
      render json: { error: 'CPF is invalid' }, status: :unprocessable_entity
    end

    def list_customers
      customers = Customer.page(params[:page]).per(params[:per_page] || 10)

      render json: { customers: customers }, status: :ok
    end
  end
end
