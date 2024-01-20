# frozen_string_literal: true

class Customer < ApplicationRecord
  validates :name, presence: true
  validates :cpf, presence: true, uniqueness: true
  validates :date_of_birth, presence: true

  validate :validating_cpf

  private

  def validating_cpf
    errors.add(:cpf, 'is invalid') unless cpf_valid?(cpf)
  end

  def cpf_valid?(cpf)
    return false if cpf.nil?

    cpf_digits = extract_digits(cpf)

    return false unless valid_length_uniqueness?(cpf_digits)

    first_digit = calculate_digit(cpf_digits, 10)

    second_digit = calculate_digit(cpf_digits, 11)

    first_digit == cpf_digits[9] && second_digit == cpf_digits[10]
  end

  def extract_digits(cpf)
    cpf.gsub!(/\D/, '')
    cpf.scan(/\d/).map(&:to_i)
  end

  def valid_length_uniqueness?(digits)
    digits.length == 11 && digits.uniq.length != 1
  end

  def calculate_digit(digits, factor)
    sum = digits.first(factor - 1).each_with_index.sum { |number, index| number * (factor - index) }
    sum % 11 < 2 ? 0 : 11 - (sum % 11)
  end
end
