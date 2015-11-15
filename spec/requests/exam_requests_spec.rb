require 'rails_helper'

RSpec.describe "ExamRequests", type: :request do
  before(:each) do
    @employee = create :employee
    @tag = create :tag
    @exam_attr ={ exam_time: Time.now + 2.days, tag_id: @tag.id }
    @exam_request = @employee.exam_requests.create(@exam_attr)
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
      employee = create :employee

      5.times do |i|
        attrs = attributes_for :exam_request, title: "title_#{i}"
        employee.exam_requests.create attrs
      end

      login(employee)
      get "/members/#{employee.id}/exam_requests"
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data.size).to eq(5)
      first = data[0]
      expect(first["title"]).to eq("title_0")
    end
  end

  describe "process exam_requests" do
    before(:each) do
      @employee = create :employee
      @manager = create :manager
      @employee.assign_to @manager

      leave_attrs = attributes_for :exam_request
      @exam_request = @employee.exam_requests.create leave_attrs
    end

    it "should approve request" do
      login(@manager)
      post "/members/#{@employee.id}/exam_requests/#{@exam_request.id}/processed", approved: true
      expect(response).to have_http_status 200
      @exam_request.reload
      expect(@exam_request.approved?).to be(true)
    end

    it "should reject request" do
      login(@manager)
      post "/members/#{@employee.id}/exam_requests/#{@exam_request.id}/processed", rejected: true
      expect(response).to have_http_status 200
      @exam_request.reload
      expect(@exam_request.rejected?).to be(true)
    end

    it "should 403 if not employee's manger" do
      login(@employee)
      post "/members/#{@employee.id}/exam_requests/#{@exam_request.id}/processed", rejected: true
      expect(response).to have_http_status 403
    end
  end
end
