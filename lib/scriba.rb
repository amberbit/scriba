require 'mongoid'
require "scriba/logger"
require "scriba/activerecord" if defined?(ActiveRecord)
require "scriba/middleware"
require "scriba/engine"
require "will_paginate"
require "will_paginate_mongoid"
require "haml"

module Scriba
  mattr_accessor :user_finder, :user_path_finder
end
