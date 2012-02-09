require 'sinatra'
require_relative '../app'
require 'rack/test'
require 'rspec'

def app
    Sinatra::Application
end

describe "WIO" do
    include Rack::Test::Methods

    before(:all) do
        get '/flush'
    end

    describe "routes" do
        it "should respond to /" do
            get '/'
            last_response.should be_ok
        end

        it "should return a list of WIO from /wio" do
            get '/wio'
            last_response.should be_ok
            last_response.body.should_not be_empty
        end

        it "should be able to add a new user id to WIO by POST /wio/:id" do
            post '/wio/1'
            last_response.should be_ok

            get '/wio'
            last_response.should be_ok
            last_response.body.should == "[\"1\"]"
        end

        it "should be able to flush memcache by GET /flush" do
            get '/flush'
            last_response.should be_ok

            get '/wio'
            last_response.should be_ok
            last_response.body.should == "[]"
        end
    end
end
