# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Customers' do
  let(:valid_attributes) { attributes_for(:customer) }

  describe 'POST /customers' do
    context 'when valid parameters' do
      before { post api_customers_path, params: { customer: valid_attributes } }

      it 'returns status 201' do
        expect(response).to have_http_status(:created)
      end

      it 'returns the customer with the correct name' do
        expect(json_body[:customer][:name]).to eq(valid_attributes[:name])
      end
    end

    context 'when invalid parameters' do
      before { post(api_customers_path, params: { customer: valid_attributes.merge(name: nil) }) }

      it 'returns status 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns customer' do
        expect(json_errors).to include("Name can't be blank")
      end
    end

    context 'when invalid cpf' do
      before { post(api_customers_path, params: { customer: valid_attributes.merge(cpf: '012.321.543-12') }) }

      it 'returns status 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns customer' do
        expect(json_errors).to include('Cpf is invalid')
      end
    end

    context 'when creating a customer with formatted CPF' do
      before { post(api_customers_path, params: { customer: valid_attributes }) }

      it 'returns status 201' do
        expect(response).to have_http_status(:created)
      end

      it 'saves the customer with a clean CPF' do
        customer = Customer.last

        expect(customer.cpf).to eq(valid_attributes[:cpf].gsub!(/\D/, ''))
      end
    end

    context 'when try creating a duplicate customer' do
      let!(:customer) { create(:customer) }
      let(:customer_attributes) { customer.attributes }

      before { post(api_customers_path, params: { customer: customer_attributes }) }

      it 'returns status 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'saves the customer with a clean CPF' do
        expect(json_errors).to include('Cpf has already been taken')
      end
    end
  end

  describe 'GET /customers' do
    context 'when there are no customers registered' do
      before { get api_customers_path }

      it 'returns status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns an empty array' do
        expect(json_body[:customers]).to be_empty
      end
    end

    context 'when there are customers registered' do
      before do
        create_list(:customer, 10)

        get api_customers_path, params: { page: 2, per_page: 5 }
      end

      it 'returns status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns customers' do
        expect(json_body[:customers]).not_to be_empty
      end

      it 'returns the correct number of customers' do
        expect(json_body[:customers].length).to eq(5)
      end

      it 'paginates the customers correctly' do
        expect(json_body[:customers].first[:id]).to eq(Customer.offset(5).limit(1).first.id)
      end
    end

    context 'when searching for a customer by CPF is successful' do
      let!(:customer) { create(:customer) }

      before { get api_customers_path, params: { cpf: customer.cpf } }

      it 'returns status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'return customer' do
        expect(json_body[:customer][:cpf]).to eq(customer.cpf)
      end
    end

    context 'when searching for a customer by CPF is not found' do
      let(:customer) { create(:customer) }

      before { get api_customers_path, params: { cpf: CPF.new(CPF.generate).formatted } }

      it 'returns status 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns customer not found message' do
        expect(json_errors).to eq('Customer not found')
      end
    end

    context 'when searching for a customer by CPF is invalid' do
      let(:customer) { create(:customer) }

      before { get api_customers_path, params: { cpf: '000.000.000-00' } }

      it 'returns status 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns customer invalid message' do
        expect(json_errors).to eq('CPF is invalid')
      end
    end
  end
end
