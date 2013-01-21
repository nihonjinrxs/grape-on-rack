require 'rubygems'

ENV["RACK_ENV"] ||= 'test'

require 'rack/test'

require File.expand_path("../../config/environment", __FILE__)

require 'factory_girl_rails'
RSpec.configure do |config|
  config.mock_with :rspec
  config.expect_with :rspec
  config.include FactoryGirl::Syntax::Methods
end

require 'capybara/rspec'
Capybara.configure do |config|
  config.app = Acme::App.new
  config.server_port = 9293
end
