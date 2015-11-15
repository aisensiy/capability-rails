require 'rails_helper'

RSpec.describe "exam_papers/index", type: :view do
  before(:each) do
    assign(:exam_papers, [
      ExamPaper.create!(
        :index => "Index",
        :create => "Create",
        :show => "Show"
      ),
      ExamPaper.create!(
        :index => "Index",
        :create => "Create",
        :show => "Show"
      )
    ])
  end

  it "renders a list of exam_papers" do
    render
    assert_select "tr>td", :text => "Index".to_s, :count => 2
    assert_select "tr>td", :text => "Create".to_s, :count => 2
    assert_select "tr>td", :text => "Show".to_s, :count => 2
  end
end
