# frozen_string_literal: true

module CpfValidator
  def self.valid?(cpf)
    return false if cpf.nil?

    cpf_digits = extract_digits(cpf)

    return false unless valid_length_uniqueness?(cpf_digits)

    first_digit = calculate_digit(cpf_digits, 10)

    second_digit = calculate_digit(cpf_digits, 11)

    first_digit == cpf_digits[9] && second_digit == cpf_digits[10]
  end

  def self.extract_digits(cpf)
    cpf.gsub!(/\D/, '')
    cpf.scan(/\d/).map(&:to_i)
  end

  def self.valid_length_uniqueness?(digits)
    digits.length == 11 && digits.uniq.length != 1
  end

  def self.calculate_digit(digits, factor)
    sum = digits.first(factor - 1).each_with_index.sum { |number, index| number * (factor - index) }
    sum % 11 < 2 ? 0 : 11 - (sum % 11)
  end
end
