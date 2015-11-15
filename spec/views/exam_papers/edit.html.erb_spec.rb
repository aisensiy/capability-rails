require 'rails_helper'

RSpec.describe "exam_papers/edit", type: :view do
  before(:each) do
    @exam_paper = assign(:exam_paper, ExamPaper.create!(
      :index => "MyString",
      :create => "MyString",
      :show => "MyString"
    ))
  end

  it "renders the edit exam_paper form" do
    render

    assert_select "form[action=?][method=?]", exam_paper_path(@exam_paper), "post" do

      assert_select "input#exam_paper_index[name=?]", "exam_paper[index]"

      assert_select "input#exam_paper_create[name=?]", "exam_paper[create]"

      assert_select "input#exam_paper_show[name=?]", "exam_paper[show]"
    end
  end
end
