require 'rails_helper'

RSpec.describe "exam_requests/edit", type: :view do
  before(:each) do
    @exam_request = assign(:exam_request, ExamRequest.create!())
  end

  it "renders the edit exam_request form" do
    render

    assert_select "form[action=?][method=?]", exam_request_path(@exam_request), "post" do
    end
  end
end
