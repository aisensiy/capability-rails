require 'rails_helper'

RSpec.describe "exam_papers/show", type: :view do
  before(:each) do
    @exam_paper = assign(:exam_paper, ExamPaper.create!(
      :index => "Index",
      :create => "Create",
      :show => "Show"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Index/)
    expect(rendered).to match(/Create/)
    expect(rendered).to match(/Show/)
  end
end
