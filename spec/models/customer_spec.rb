# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Customer do
  it 'is valid with valid attributes' do
    customer = build(:customer)

    expect(customer).to be_valid
  end

  it 'when name is null' do
    customer = build(:customer, name: nil)
    customer.valid?

    expect(customer.errors[:name]).to include("can't be blank")
  end

  it 'when date_of_birth is null' do
    customer = build(:customer, date_of_birth: nil)
    customer.valid?

    expect(customer.errors[:date_of_birth]).to include("can't be blank")
  end

  it 'when cpf is null' do
    customer = build(:customer, cpf: nil)
    customer.valid?

    expect(customer.errors[:cpf]).to include("can't be blank")
  end

  context 'when cpf is not unique' do
    let!(:client) { create(:customer) }

    it "includes 'has already been taken' in cpf errors" do
      customer = build(:customer, cpf: client.cpf)
      customer.valid?

      expect(customer.errors[:cpf]).to include('has already been taken')
    end
  end
end
