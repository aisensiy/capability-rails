require 'rails_helper'

RSpec.describe "exam_requests/index", type: :view do
  before(:each) do
    assign(:exam_requests, [
      ExamRequest.create!(),
      ExamRequest.create!()
    ])
  end

  it "renders a list of exam_requests" do
    render
  end
end
