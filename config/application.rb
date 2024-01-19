require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module IgmaApp
  class Application < Rails::Application
    config.load_defaults 7.1
    config.autoload_lib(ignore: %w(assets tasks))
    config.generators.system_tests = nil
    config.api_only = true

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot, dir: 'spec/factories'

      # Disable generation of helpers, javascripts, css, and view specs
      g.helper false
      g.assets false
      g.view_specs false 
    end
  end
end
