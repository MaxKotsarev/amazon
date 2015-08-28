require 'rails_helper'
require 'capybara/rspec'
require 'capybara/webkit/matchers'

# Add additional requires below this line. Rails is not loaded until this point!
require 'support/warden.rb'
require 'devise'
Capybara.javascript_driver = :webkit