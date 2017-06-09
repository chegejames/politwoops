# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.

Rails.application.config.assets.version = '1.3'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(politwoops.js congressapi.js jquery.tmpl.min.js opencivicdataapi.js jquery.colorbox-min.js admin.css propublica_base/base.css propublica_base/master.css propublica_base/print.css propublica_base/woland.css jquery-1.7.1.min.js jquery.placehold-0.3.min.js)
