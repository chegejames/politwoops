Politwoops::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.eager_load = true
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true

  config.log_level = :debug
 

  # Specifies the header that your server uses for sending files
  #config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  #config.cache_store = :mem_cache_store,
  #  "newsapps-vpc.o2zdh0.0001.use1.cache.amazonaws.com",
  #  { :namespace => 'politwoops', compress: true }
    #{ :namespace => 'politwoops', expires_in: 1.day, compress: true }

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_files = true

  #config.action_controller.asset_host = "https://static.propublica.org"
  #config.assets.prefix = "/rails/assets/politwoops"

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  #config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
  #config.propub_url_root = "/politwoops"

  config.assets.compress =true
  config.assets.compile = true
  config.assets.digest = true

  config.paperclip_defaults = {
    :storage => :s3,
    :path => "/:attachment/:filename",
    :url => ":s3_domain_url",
    :s3_domain_url => "http://s3-eu-west-1.amazonaws.com/cfa-politwoops-ke/",
    :s3_region => "eu-west-1",
    :s3_credentials => {
      :bucket => 'cfa-politwoops-ke',
      :access_key_id =>ENV['access_key_id'],
      :secret_access_key => ENV['secret_access_key']
    },
    :interpolations => {
      :base_path => "/images"
    }
  }

end
