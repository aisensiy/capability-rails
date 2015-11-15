require 'rails_helper'

RSpec.describe "exam_papers/new", type: :view do
  before(:each) do
    assign(:exam_paper, ExamPaper.new(
      :index => "MyString",
      :create => "MyString",
      :show => "MyString"
    ))
  end

  it "renders new exam_paper form" do
    render

    assert_select "form[action=?][method=?]", exam_papers_path, "post" do

      assert_select "input#exam_paper_index[name=?]", "exam_paper[index]"

      assert_select "input#exam_paper_create[name=?]", "exam_paper[create]"

      assert_select "input#exam_paper_show[name=?]", "exam_paper[show]"
    end
  end
end
