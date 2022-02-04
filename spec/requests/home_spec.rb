require 'rails_helper'

RSpec.describe "Home Page", type: :request do
  describe "GET /" do
    it "return status 200" do
      get '/'
      expect(response).to have_http_status(:ok)
    end
  end
end
