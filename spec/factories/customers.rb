# frozen_string_literal: true

FactoryBot.define do
  factory :customer do
    name { Faker::Name.name }
    cpf { CPF.generate(true) }
    date_of_birth { Faker::Date.birthday(min_age: 18, max_age: 65) }
  end
end
