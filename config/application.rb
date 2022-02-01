require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Icecreamtruck
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.exceptions_app = self.routes

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.time_zone = "UTC"
    config.eager_load_paths << Rails.root.join("lib/modules")
    
    config.generators do |g|
      g.test_framework :rspec
      g.fixtures false
      g.view_specs false
      g.helper_specs false
      g.routing_specs false
      g.stylesheets false
      g.javascripts false
      g.helpers false
    end
  end
end
