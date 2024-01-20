# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Customers' do
  let(:valid_attributes) { attributes_for(:customer) }

  describe 'POST /customers' do
    context 'when valid parameters' do
      before { post(api_customers_path, params: { customer: valid_attributes }) }

      it 'returns status 201' do
        expect(response).to have_http_status(:created)
      end

      it 'returns guest' do
        expect(json_body[:customer][:name]).to eq(valid_attributes[:name])
      end
    end

    context 'when invalid parameters' do
      before { post(api_customers_path, params: { customer: valid_attributes.merge(name: nil) }) }

      it 'returns status 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns guest' do
        expect(json_errors).to include("Name can't be blank")
      end
    end

    context 'when invalid cpf' do
      before { post(api_customers_path, params: { customer: valid_attributes.merge(cpf: '012.321.543-12') }) }

      it 'returns status 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns guest' do
        expect(json_errors).to include('Cpf is invalid')
      end
    end
  end
end
