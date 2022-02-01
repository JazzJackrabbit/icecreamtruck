require 'rails_helper'

RSpec.describe "Web Errors", type: :request do
  describe "GET non-existing route" do
    it "handles the routing error and returns a 404 page" do
      get "/qwerty"
      expect(response).to have_http_status(:not_found)
    end
  end
end
