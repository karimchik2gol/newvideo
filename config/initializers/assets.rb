# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path
Rails.application.config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
Rails.application.config.assets.precompile += %w( .svg .eot .woff .ttf)

Rails.application.config.assets.paths << Rails.root.join("app", "assets", "plugins")
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "pages")
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "stylesheets", "fonts")

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( admin.css datatable.css fileupload.css) # CSS
Rails.application.config.assets.precompile += %w( admin.js datatable.js errors.js fileupload.js float.js) # JS