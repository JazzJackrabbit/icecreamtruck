require 'rails_helper'

RSpec.describe "Web Errors", type: :request do
  describe "GET non-existing route" do
    it "handles the routing error and returns a 404 page" do
      get "/qwerty"
      expect(response).to have_http_status(:not_found)
    end

    it "has a page for an internal server error route" do
      get '/500'
      expect(response).to have_http_status(:internal_server_error)
    end
  end
end
