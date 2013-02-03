require_relative '../app/models/user.rb'
require 'logger'

module Acme
  class API_v6 < Grape::API
    version 'v6', :using => :path, :vendor => 'acme', :format => :json
    desc "Provides access to the user object, which is stored to the database."

    logger = Logger.new('log/app_debug.log', 10, 2048000)

    resource :users do
      # GET /api/v6/users
      desc "Get the currently available users"
      params do
        optional :limit, type: Integer, desc: "The number of users to return"
      end
      get do
        response_limit = params[:limit] || 20
        response_json = { :body => [] }
        users = User.order("name").limit(response_limit)
        logger.debug { "users = #{users.to_s}"}
        users.each do |user|
          logger.debug { "GET /api/v6/users -- in loop with current user = #{user.to_s}, limit = #{response_limit}" }
          response_json[:body] << { :id => user.id, :name => user.name }
        end
        logger.debug "In API_v6#:users#get --> response_json = \"#{response_json.to_json}\" = \"#{response_json.to_s}\""
        response_json.to_json
      end

      # POST /api/v6/users { name = ... }
      desc "Create a new user"
      params do
        requires :name, type: String, regexp: /^[A-Z][a-zA-Z'\-]+$/, desc: "A user's name"
      end
      post do
        logger.debug { "POST /api/v6/users with ?name=#{params[:name]}: attempting User.create(...)" }
        logger.debug { "User.connected? = #{if User.connected? then 'true' else 'false' end}" }
        logger.debug { "User.configurations = #{User.configurations}" }
        @user = User.create(:name => params[:name])
        logger.debug { "POST /api/v6/users with ?name=#{params[:name]}: resulting @user=#{@user.to_s}" }
        logger.debug { "POST /api/v6/users with ?name=#{params[:name]}: returning #{{ :id => @user.id, :name => @user.name, :status => "created" }.to_json}" }
        { :id => @user.id, :name => @user.name, :status => "created" }
      end

      # GET /api/v6/users/:id
      desc "Get an existing user"
      params do
        requires :id, type: Integer, desc: "A user ID"
      end
      get ':id' do
        logger.debug { "GET /api/v6/users/:id with :id=#{params[:id]}" }
        @user = User.find params[:id]
        logger.debug { "User found: name = #{@user.name}" }
        { :name => @user.name }
      end

      # DELETE /api/v6/users/:id
      desc "Delete an existing user"
      params do
        requires :id, type: Integer, desc: "A user ID"
      end
      delete ':id' do
        @user = User.destroy(params[:id])
        { :id => @user.id, :status => "destroyed" }
      end

      # PUT /api/v6/users/:id { name = ... }
      desc "Update an existing user"
      params do
        requires :id, type: Integer, desc: "A user ID"
        requires :name, type: String, regexp: /^[A-Z][a-zA-Z'\-]+$/, desc: "A user's name"
      end
      put ':id' do
        logger.debug { "PUT /api/v6/users/:id with :id=#{params[:id]} and ?name=#{params[:name]}" }
        @user = User.find(params[:id])
        @user.name = params[:name]
        @user.save
        { :id => @user.id, :name => @user.name, :status => "updated" }
      end
    end
  end
end

