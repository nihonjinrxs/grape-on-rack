require_relative '../app/models/user.rb'

module Acme
  class API_v6 < Grape::API
    version 'v6', :using => :path, :vendor => 'acme', :format => :json
    desc "Provides access to the user object, which is stored to the database."
    resource :users do
      get do
        response_json = { :body => [] }
        User.find_each do |user|
          response_json[:body] << { :id => user.id, :name => user.name }
        end
        response_json.to_json
      end
      get :id do
        @user = User.find(:id)
        { :name => @user.name }
      end
      post do
        @user = User.new(:name => params[:name])
        @user.save
        { :id => user.id, :name => user.name, :status => "created" }
      end
      put :id do
        @user = User.find(:id)
        @user.name = params[:name]
        @user.save
        { :id => user.id, :name => user.name, :status => "updated" }
      end
      delete :id do
        @user = User.destroy(:id)
        { :id => user.id, :status => "destroyed" }
      end
    end
  end
end

