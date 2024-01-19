# frozen_string_literal: true

module Requests
  module JsonHelpers
    def json_body
      return unless response.body != ''

      JSON.parse(response.body, symbolize_names: true)
    end

    def json_errors
      json_body[:errors] || json_body[:error]
    end
  end
end
