require 'spec_helper'

describe Acme::API do
  include Rack::Test::Methods

  def app
    Acme::API
  end

  context "v6" do
    context "with users" do
      it "POST with name=John" do
        post "/api/v6/users?name=John"
        last_response.status.should == 201
        last_response.body.should == { :id => 1, :name => "John", :status => "created" }.to_json
        get "/api/v6/users/1"
        last_response.status.should == 201
        last_response.body.should == { :id => 1, :name => "John" }.to_json
      end
      it "PUT with id and name=James" do
        put "/api/v6/users/1?name=James"
        last_response.status.should == 200
        last_response.body.should == { :id => 1, :name => "James", :status => "updated" }.to_json
      end
    end
    it "GET users" do
      get "/api/v6/users"
      last_response.body.should == { :body => [ { :id => 1, :name => "James" } ] }.to_json
    end
    id "DELETE users with id" do
      delete "/api/v6/users/1"
      last_response.body.should == { :id => 1, :name => "James", :status => "destroyed" }.to_json
    end
  end

end

