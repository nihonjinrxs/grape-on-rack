$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'api'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'boot'

Bundler.require :default, ENV['RACK_ENV']
require 'active_record'
require 'logger'
logger = Logger.new('log/app_debug.log', 10, 2048000)

config = YAML::load(File.open('./db/config.yml'))
logger.debug "db/config = #{config.to_s}"

ActiveRecord::Base.establish_connection(config[ENV['RACK_ENV']])
logger.info "ActiveRecord::Base.establish_connection -- connection established to #{config[ENV['RACK_ENV']]}"
logger.debug { "ActiveRecord::Base.connected? = #{if ActiveRecord::Base.connected? then 'true' else 'false' end}" }
logger.debug { "ActiveRecord::Base.configurations = #{ActiveRecord::Base.configurations}" }
logger.debug { "ActiveRecord::Base.connection = #{ActiveRecord::Base.connection}" } unless not ActiveRecord::Base.connected?

Dir[File.expand_path('../../app/models/*.rb', __FILE__)].each do |f|
  require f
end

Dir[File.expand_path('../../api/api_v*.rb', __FILE__)].each do |f|
  require f
end

require 'api'
require 'acme_app'

