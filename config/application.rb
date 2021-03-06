require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Workspace
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    
    config.autoload_paths += %W(#{config.root}/lib)
    
    # Feature map: what features are enabled?
    require "#{config.root}/lib/feature_map"
    config.feature_map = FeatureMap.new
    
    # Markdown config. This object should be instantiated once, not per request.
    # Hence, it's here.
    config.markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
      {:autolink => true, :space_after_headers => true, :quote => true })
      
    # Set Active Job backend to delayed_job
    config.active_job.queue_adapter = :delayed_job
  end
end
