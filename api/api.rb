require 'logger'

module Acme
  class API < Grape::API
    logger Logger.new('log/debug.log', 10, 2048000)
    helpers do
      def logger
        API.logger
      end
    end
    logger.level = Logger::DEBUG

    prefix 'api'
    format :json
    mount ::Acme::API_v1
    mount ::Acme::API_v2
    mount ::Acme::API_v3
    mount ::Acme::API_v4
    mount ::Acme::API_v5
    mount ::Acme::API_v6
  end
end

