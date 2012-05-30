require 'mongoid'
require "scriba/engine"

module Scriba
  mattr_accessor :user_finder, :user_path_finder
end
