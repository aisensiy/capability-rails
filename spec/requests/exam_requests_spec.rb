require 'rails_helper'

RSpec.describe "ExamRequests", type: :request do
  before(:each) do
    @admin = create :admin
    @employee = create :employee
    @tag = create :tag
    @exam_attr ={ exam_time: Time.now + 2.days, tag_id: @tag.id }
    @exam_request = @employee.exam_requests.create(@exam_attr)
    @exam_paper = @tag.exam_papers.create attributes_for(:exam_paper)
  end
  describe "create new exam_request" do
    it "should 403 without employee_id login" do
      employee2 = create :employee, name: 'two'
      login employee2
      post "/members/#{@employee.id}/exam_requests", exam_request: @exam_attr
      expect(response).to have_http_status(403)
    end

    it "create new exam_request with valide input" do
      login @employee
      post "/members/#{@employee.id}/exam_requests", exam_request: @exam_attr
      exam_request = @employee.reload.exam_requests.last
      expect(response).to have_http_status(201)
      expect(response.headers['Location']).to end_with("/exam_requests/#{exam_request.id}")
    end

    it 'should fail with invalid input' do
      login @employee
      post "/members/#{@employee.id}/exam_requests", exam_request: {'abc' => '123'}
      expect(response).to have_http_status(400)
    end
  end

  describe "get one exam_request" do
    it "should get one exam_request" do
      login(@employee)
      get "/members/#{@employee.id}/exam_requests/#{@exam_request.id}"
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data['exam_time'].to_datetime.strftime("%Y-%M-%D %H:%m:%s")).to eq(@exam_request.exam_time.strftime("%Y-%M-%D %H:%m:%s"))
      expect(data['status']).to eq(@exam_request.status.to_s)
    end

    it "should 404" do
      login(@employee)
      get "/members/#{@employee.id}/exam_requests/123"
      expect(response).to have_http_status(404)
    end
  end

  describe "list exam_requests" do
    it "should list exam_requests" do
      5.times do |i|
        @employee.exam_requests.create @exam_attr
      end

      login(@employee)
      get "/members/#{@employee.id}/exam_requests"
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data.size).to eq(6)
      first = data[0]
      expect(first['exam_time'].to_datetime.strftime("%Y-%M-%D %H:%m:%s")).to eq(@exam_request.exam_time.strftime("%Y-%M-%D %H:%m:%s"))
    end
  end

  describe "process exam_requests" do
    it "should confirm request" do
      login(@admin)
      post "/members/#{@employee.id}/exam_requests/#{@exam_request.id}/processed", state: "confirmed"
      expect(response).to have_http_status 200
      @exam_request.reload
      expect(@exam_request.status).to eq("confirmed")
    end

    it "should reject request" do
      login(@admin)
      post "/members/#{@employee.id}/exam_requests/#{@exam_request.id}/processed", state: "rejected"
      expect(response).to have_http_status 200
      @exam_request.reload
      expect(@exam_request.status).to eq("rejected")
    end

    it "should cancel exam" do
      login(@admin)
      @exam_request.status = "confirmed"
      @exam_request.save
      post "/members/#{@employee.id}/exam_requests/#{@exam_request.id}/processed", state: "cancelled"
      expect(response).to have_http_status 200
      @exam_request.reload
      expect(@exam_request.status).to eq("cancelled")
    end

    it "should start exam" do
      login(@admin)
      @exam_request.status = "confirmed"
      @exam_request.save
      post "/members/#{@employee.id}/exam_requests/#{@exam_request.id}/processed", state: "started", exam_paper_id: @exam_paper.id
      expect(response).to have_http_status 200
      @exam_request.reload
      expect(@exam_request.status).to eq("started")
      expect(@exam_request.exam_paper_id).to eq(@exam_paper.id.to_s)
    end

    it 'should finish exam' do
      login(@admin)
      @exam_request.status = "started"
      @exam_request.save
      post "/members/#{@employee.id}/exam_requests/#{@exam_request.id}/processed", state: "finished", grade: 100
      expect(response).to have_http_status 200
      @exam_request.reload
      expect(@exam_request.status).to eq("finished")
      expect(@exam_request.grade).to eq(100)
    end

    it "should 403 if not admin" do
      login(@employee)
      post "/members/#{@employee.id}/exam_requests/#{@exam_request.id}/processed", state: "confirmed"
      expect(response).to have_http_status 403
    end
  end
end
