require "rails_helper"

RSpec.describe ExamPapersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/exam_papers").to route_to("exam_papers#index")
    end

    it "routes to #new" do
      expect(:get => "/exam_papers/new").to route_to("exam_papers#new")
    end

    it "routes to #show" do
      expect(:get => "/exam_papers/1").to route_to("exam_papers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/exam_papers/1/edit").to route_to("exam_papers#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/exam_papers").to route_to("exam_papers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/exam_papers/1").to route_to("exam_papers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/exam_papers/1").to route_to("exam_papers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/exam_papers/1").to route_to("exam_papers#destroy", :id => "1")
    end

  end
end
