# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'rspec/rails'
require 'pry'

ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(ENGINE_RAILS_ROOT, "spec/support/**/*.rb")].each {|f| require f }

RSpec.configure do |config|
  config.before :each do
    Scriba.user_finder = Scriba.user_path_finder = nil
    begin
      Scriba::Request.collection.drop
    rescue Moped::Errors::OperationFailure => e
    end
  end
end
