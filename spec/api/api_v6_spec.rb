require 'spec_helper'

logger = Logger.new('log/rspec.log', 10, 2048000)
logger.level = Logger::DEBUG

describe Acme::API do
  include Rack::Test::Methods

  def app
    Acme::API
  end

  logger.debug "*** Starting Acme::API testing ***"
  context "v6" do
    logger.debug "***** In context v6 *****"

    it "POST with name=John" do
      logger.debug "***** Testing 'POST with name=John' *****"
      post "/api/v6/users?name=John"
      logger.debug "POST test\nlast_response = #{last_response.to_json}"
      last_response.status.should == 201
      logger.debug "POST test\nlast_response.body = #{last_response.body}"
      logger.debug "POST test\nlast_response.body['id'] = #{last_response.body['id']}"
      logger.debug "POST test\nlast_response.body['name'] = #{last_response.body['name']}"
      last_response.body["id"].should exist
      @test_id = last_response.body.first[:id]
      logger.debug "  -> @test_id = #{@test_id}"
      last_response.body["name"].should == "John"
      last_response.body["status"].should == "created"
    end

    it "GET with id" do
      logger.debug "***** Testing 'GET with id' *****"
      get "/api/v6/users/#{@test_id}"
      logger.debug "GET :id test\nlast_response = #{last_response.to_json}\n@test_id = #{@test_id}"
      last_response.status.should == 201
      last_response.body.should == [{ :id => @test_id, :name => "John" }.to_json]
    end

    it "PUT with id and name=James" do
      logger.debug "***** Testing 'PUT with id and name=James' *****"
      put "/api/v6/users/#{@test_id}?name=James"
      logger.debug "PUT :id test\nlast_response = #{last_response.to_json}\n@test_id = #{@test_id}"
      last_response.status.should == 200
      last_response.body.should == [{ :id => @test_id, :name => "James", :status => "updated" }.to_json]
    end

    it "GET users" do
      logger.debug "***** Testing 'GET' *****"
      get "/api/v6/users"
      logger.debug "GET test\nlast_response = #{last_response.to_json}\n@test_id = #{@test_id}"
      last_response.body[:body][:body].should include({ :id => @test_id, :name => "James" }.to_json)
    end

    it "DELETE users with id" do
      logger.debug "***** Testing 'DELETE with id' *****"
      delete "/api/v6/users/#{@test_id}"
      logger.debug "DELETE :id test\nlast_response = #{last_response.to_json}\n@test_id = #{@test_id}"
      last_response.body.should == [{ :id => 1, :name => "James", :status => "destroyed" }.to_json]
    end

    logger.debug "***** Leaving context v6 *****"
  end

  logger.debug "*** Finished Acme::API testing ***"
end

