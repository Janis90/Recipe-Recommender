require "rails_helper"

RSpec.describe AllergiesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/allergies").to route_to("allergies#index")
    end

    it "routes to #new" do
      expect(:get => "/allergies/new").to route_to("allergies#new")
    end

    it "routes to #show" do
      expect(:get => "/allergies/1").to route_to("allergies#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/allergies/1/edit").to route_to("allergies#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/allergies").to route_to("allergies#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/allergies/1").to route_to("allergies#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/allergies/1").to route_to("allergies#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/allergies/1").to route_to("allergies#destroy", :id => "1")
    end

  end
end
