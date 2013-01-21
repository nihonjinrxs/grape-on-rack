require 'rubygems'
require 'bundler'
require 'logger'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'

logger = Logger.new('log/rake_tasks.log', 10, 2048000)
logger.level = Logger::DEBUG
logger.info "Logger created at log/rake_tasks.log"

require 'standalone_migrations'
StandaloneMigrations::Tasks.load_tasks
logger.info "StandaloneMigrations::Tasks.load_tasks completed"

config = YAML::load(File.open('./db/config.yml'))
logger.debug "config = #{config.to_s}"

=begin
require 'tasks/standalone_migrations'
StandaloneMigrations::Configurator.environments_config do |env|
  env.on "production" do
    if (ENV['DATABASE_URL'])
      db = URI.parse(ENV['DATABASE_URL'])
      return {
          :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
          :host     => db.host,
          :username => db.user,
          :password => db.password,
          :database => db.path[1..-1],
          :encoding => 'utf8'
      }
    end
    nil
  end
end
=end
logger.info "Skipped custom database config necessary for Heroku deployment (temporarily)"

ActiveRecord::Base.establish_connection(config["development"])
logger.info "ActiveRecord::Base.establish_connection -- connection established to #{config['development']}"

begin
  require "rspec/core"
  require "rspec/core/rake_task"

  RSpec::Core::RakeTask.new(:spec) do |spec|
    # do not run integration tests, doesn't work on TravisCI
    spec.pattern = FileList['spec/api/*_spec.rb']
  end
  logger.info "Loaded RSpec and created RakeTask :spec"
rescue LoadError
  logger.error "rspec/core or rspec/core/rake_task caused a LoadError"
end

task :default => :spec
