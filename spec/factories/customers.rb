# frozen_string_literal: true

FactoryBot.define do
  factory :customer do
    name { Faker::Name.name }
    cpf { CPF.new(CPF.generate).formatted }
    date_of_birth { Faker::Date.birthday(min_age: 18, max_age: 65) }
  end
end
