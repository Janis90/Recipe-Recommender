require 'rails_helper'

RSpec.describe "Allergies", type: :request do
  describe "GET /allergies" do
    it "works! (now write some real specs)" do
      get allergies_path
      expect(response).to have_http_status(200)
    end
  end
end
