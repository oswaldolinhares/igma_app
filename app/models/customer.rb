# frozen_string_literal: true

class Customer < ApplicationRecord
  before_save :clean_cpf

  validates :name, presence: true
  validates :cpf, presence: true, uniqueness: true
  validates :date_of_birth, presence: true

  validate :validating_cpf

  private

  def validating_cpf
    errors.add(:cpf, 'is invalid') unless CpfValidator.valid?(cpf)
  end

  def clean_cpf
    cpf.gsub!(/\D/, '')
  end
end
