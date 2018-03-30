class API::BaseController < ActionController::Base
  layout 'response'
  respond_to :json
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
end