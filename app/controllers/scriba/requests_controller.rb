class Scriba::RequestsController < Scriba::ApplicationController
  def show
    @request = Scriba::Request.find params[:id]
  end
end
