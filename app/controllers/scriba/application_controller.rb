module Scriba
  class ApplicationController < ActionController::Base
    before_filter :auth

    private

    def auth
      Scriba.auth_handler.bind(self).call if Scriba.auth_handler.is_a? Proc
    end
  end
end
