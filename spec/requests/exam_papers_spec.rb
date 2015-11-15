require 'rails_helper'

RSpec.describe "ExamPapers", type: :request do
  before(:each) do
    @tag = create :tag
    @admin = create :admin
    exam_paper_attrs = attributes_for :exam_paper
    @exam_paper = @tag.exam_papers.create exam_paper_attrs
  end

  describe "create new exam_paper" do
    it "should 403 without admin login" do
      employee = create :employee, name: 'two'
      exam_paper_attrs = attributes_for :exam_paper
      login employee
      post "/tags/#{@tag.id}/exam_papers", exam_paper: exam_paper_attrs
      expect(response).to have_http_status(403)
    end

    it "create new exam_paper with valide input" do
      exam_paper_attrs = attributes_for :exam_paper
      login @admin
      post "/tags/#{@tag.id}/exam_papers", exam_paper: exam_paper_attrs
      exam_paper = @tag.reload.exam_papers.last
      expect(response).to have_http_status(201)
      expect(response.headers['Location']).to end_with("/tags/#{@tag.id}/exam_papers/#{exam_paper.id}")
    end

    it 'should fail with invalid input' do
      login @admin
      post "/tags/#{@tag.id}/exam_papers", exam_paper: {'abc' => '123'}
      expect(response).to have_http_status(400)
    end
  end

  describe "get one exam_paper" do
    it "should get one exam_paper" do
      login(@admin)
      get "/tags/#{@tag.id}/exam_papers/#{@exam_paper.id}"
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data['name']).to eq(@exam_paper.name)
      expect(data['description']).to eq(@exam_paper.description)
    end

    it "should 403 if not admin" do
      employee = create :employee
      login(employee)
      get "/tags/#{@tag.id}/exam_papers/#{@exam_paper.id}"
      expect(response).to have_http_status(403)
    end

    it "should 404" do
      login(@admin)
      get "/tags/#{@tag.id}/exam_papers/123"
      expect(response).to have_http_status(404)
    end
  end

  describe "list exam_papers" do
    it "should list exam_papers" do
      5.times do |i|
        attrs = attributes_for :exam_paper, date: "2015-11-0#{i + 1}"
        @tag.exam_papers.create attrs
      end

      login(@tag)
      get "/tags/#{@tag.id}/exam_papers"
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data.size).to eq(6)
      first = data[-1]
      expect(first["date"]).to eq("2015-11-05")
    end
  end
end
