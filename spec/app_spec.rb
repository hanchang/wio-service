require 'rack/test'
require 'rspec'

# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

describe "App" do
    include Rack::Test::Methods

    describe "Target routes" do

        it "should respond to /" do
            get '/'
            last_response.should be_ok
        end
    end
end
