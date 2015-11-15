require 'rails_helper'

RSpec.describe "exam_requests/new", type: :view do
  before(:each) do
    assign(:exam_request, ExamRequest.new())
  end

  it "renders new exam_request form" do
    render

    assert_select "form[action=?][method=?]", exam_requests_path, "post" do
    end
  end
end
