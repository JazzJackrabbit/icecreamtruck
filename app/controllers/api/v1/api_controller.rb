class Api::V1::ApiController < ApplicationController
  protect_from_forgery with: :null_session
  
  include AppErrors::Rescuable
  include Api::V1::ApiHelper

  def route_not_found
    raise AppErrors::API::RouteNotFoundError
  end
end
