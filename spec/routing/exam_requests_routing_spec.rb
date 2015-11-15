require "rails_helper"

RSpec.describe ExamRequestsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/exam_requests").to route_to("exam_requests#index")
    end

    it "routes to #new" do
      expect(:get => "/exam_requests/new").to route_to("exam_requests#new")
    end

    it "routes to #show" do
      expect(:get => "/exam_requests/1").to route_to("exam_requests#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/exam_requests/1/edit").to route_to("exam_requests#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/exam_requests").to route_to("exam_requests#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/exam_requests/1").to route_to("exam_requests#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/exam_requests/1").to route_to("exam_requests#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/exam_requests/1").to route_to("exam_requests#destroy", :id => "1")
    end

  end
end
