# Be sure to restart your server when you modify this file.

# Datahub::Application.config.session_store :cookie_store, :key => '_datahub_session'
Datahub::Application.config.session_store :redis_store, :namespace => "datahub:#{Rails.env}:session",
  :key => "_datahub_#{Rails.env}_session"

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Datahub::Application.config.session_store :active_record_store
