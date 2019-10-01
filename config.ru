# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

# Nuevo
require 'bootstrap-sass' #require statement of bootstrap-sass

run Rails.application
