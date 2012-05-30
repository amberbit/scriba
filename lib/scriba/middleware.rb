module Scriba
  class Middleware
    def initialize(app, options = {})
      @app, @options = app, options
    end

    def call(env)
      Scriba::Request.log(env) do |e|
        begin
          @app.call(e)
        rescue Exception => exception
          raise
        end
      end
    end
  end
end
