require_relative '../app/models/user.rb'

module Acme
  class API_v6 < Grape::API
    version 'v6', :using => :path, :vendor => 'acme', :format => :json
    desc "Provides access to the user object, which is stored to the database."

    resource :users do
      desc "Get the currently available users"
      params do
        optional :limit, type: Integer, desc: "The number of users to return"
      end
      get do
        response_limit = params[:limit] || 20
        response_json = { :body => [] }
        User.order('name ASC').limit(response_limit) do |user|
          logger.debug { "GET /api/v6/users -- in loop with current user = #{user.to_s}, limit = #{response_limit}" }
          response_json[:body] << { :id => user.id, :name => user.name }
        end
        response_json.to_json
      end

      params do
        requires :name, type: String, regexp: /^[A-Z][a-zA-Z'\-]+$/, desc: "A user's name"
      end
      desc "Create a new user"
      post do
        logger.debug { "POST /api/v6/users with ?name=#{params[:name]}: attempting User.create(...)" }
        @user = User.create(:name => params[:name])
        logger.debug { "POST /api/v6/users with ?name=#{params[:name]}: resulting @user=#{@user.to_s}" }
        logger.debug { "POST /api/v6/users with ?name=#{params[:name]}: returning #{{ :id => @user.id, :name => @user.name, :status => "created" }.to_json}" }
        { :id => @user.id, :name => @user.name, :status => "created" }
      end

      namespace :id do
        params do
          requires :id, type: Integer, desc: "A user ID"
        end
        desc "Get an existing user"
        get ':id' do
          @user = User.find(:id)
          { :name => @user.name }
        end

        desc "Delete an existing user"
        delete ':id' do
          @user = User.destroy(:id)
          { :id => @user.id, :status => "destroyed" }
        end

        desc "Update an existing user"
        params do
          requires :name, type: String, regexp: /^[A-Z][a-zA-Z'\-]+$/, desc: "A user's name"
        end
        put ':id' do
          logger.debug { "PUT /api/v6/users/:id with :id=#{:id} and ?name=#{params[:name]}" }
          @user = User.find(:id)
          @user.name = params[:name]
          @user.save
          { :id => @user.id, :name => @user.name, :status => "updated" }
        end
      end
    end
  end
end

