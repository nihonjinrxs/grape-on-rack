require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'

require 'standalone_migrations'
StandaloneMigrations::Tasks.load_tasks

config = YAML::load(File.open('./db/config.yml'))
ActiveRecord::Base.establish_connection(config[:development])

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

begin
  require "rspec/core"
  require "rspec/core/rake_task"

  RSpec::Core::RakeTask.new(:spec) do |spec|
    # do not run integration tests, doesn't work on TravisCI
    spec.pattern = FileList['spec/api/*_spec.rb']
  end
rescue LoadError
end

task :default => :spec
