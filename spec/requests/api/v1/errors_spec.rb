require 'rails_helper'

RSpec.describe "API Errors", type: :request do
  describe "GET non-existing route" do
    it "handles the routing error and returns an error message" do
      get "/api/v1/non_existing_route"
      expect(response).to have_http_status(:bad_request)
    end
  end
end
