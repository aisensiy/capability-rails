require 'rails_helper'

RSpec.describe "exam_requests/show", type: :view do
  before(:each) do
    @exam_request = assign(:exam_request, ExamRequest.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
