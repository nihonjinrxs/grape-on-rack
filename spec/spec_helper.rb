require 'rubygems'

ENV["RACK_ENV"] ||= 'test'

logger = Logger.new('log/rspec.log', 10, 2048000)
logger.level = Logger::DEBUG
logger.info "In spec_helper.rb -->"
logger.info "Logger created at log/rspec.log"

logger.info "Running in RACK_ENV=#{ENV['RACK_ENV']}"

require 'rack/test'
logger.info "Required rack/test"

require File.expand_path("../../config/environment", __FILE__)
logger.info "Loaded config/environment.rb"

require 'factory_girl_rails'
logger.info "Required factory_girl_rails"
RSpec.configure do |config|
  logger.info "RSpec.configure with config=#{config.to_s}"
  config.mock_with :rspec
  logger.info "  config.mock_with :rspec (set)"
  config.expect_with :rspec
  logger.info "  config.expect_with :rspec (set)"
  config.include FactoryGirl::Syntax::Methods
  logger.info "  config.include FactoryGirl::Syntax::Methods (set)"
end

FactoryGirl.find_definitions
logger.info "FactoryGirl.find_definitions (complete)"

require 'capybara/rspec'
logger.info "Required capybara/rspec"
Capybara.configure do |config|
  logger.info "Capybara.configure with config=#{config.to_s}"
  config.app = Acme::App.new
  logger.info "  config.app = Acme::App.new (set)"
  config.server_port = 9293
  logger.info "  config.server_port = 9293 (set)"
end
