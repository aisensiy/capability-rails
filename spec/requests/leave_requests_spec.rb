require 'rails_helper'

RSpec.describe "LeaveRequests", type: :request do
  describe "create new leave_request" do
    it "should 403 without admin login" do
      employee = create :employee
      employee2 = create :employee, name: 'two'
      leave_attrs = attributes_for :leave_request
      login employee2
      post "/members/#{employee.id}/leave_requests", leave_request: leave_attrs
      expect(response).to have_http_status(403)
    end

    it "create new leave_request with valide input" do
      employee = create :employee
      leave_attrs = attributes_for :leave_request
      login employee
      post "/members/#{employee.id}/leave_requests", leave_request: leave_attrs
      leave_request = employee.reload.leave_requests.last
      expect(response).to have_http_status(201)
      expect(response.headers['Location']).to end_with("/leave_requests/#{leave_request.id}")
    end

    it 'should fail with invalid input' do
      employee = create :employee
      login employee
      post "/members/#{employee.id}/leave_requests", leave_request: {'abc' => '123'}
      expect(response).to have_http_status(400)
    end
  end

  describe "get one leave_request" do
    it "should get one leave_request" do
      employee = create :employee
      leave_attrs = attributes_for :leave_request
      leave_request = employee.leave_requests.create leave_attrs

      login(employee)
      get "/members/#{employee.id}/leave_requests/#{leave_request.id}"
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data['title']).to eq(leave_request.title)
      expect(data['status']).to eq(leave_request.status.to_s)
    end

    it "should 404" do
      employee = create :employee
      leave_attrs = attributes_for :leave_request
      leave_request = employee.leave_requests.create leave_attrs

      login(employee)
      get "/members/#{employee.id}/leave_requests/123"
      expect(response).to have_http_status(404)
    end
  end

  describe "list leave_requests" do
    it "should list leave_requests" do
      employee = create :employee

      5.times do |i|
        attrs = attributes_for :leave_request, title: "title_#{i}"
        employee.leave_requests.create attrs
      end

      login(employee)
      get "/members/#{employee.id}/leave_requests"
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data.size).to eq(5)
      first = data[0]
      expect(first["title"]).to eq("title_0")
    end
  end

  describe "process leave_requests" do
    before(:each) do
      @employee = create :employee
      @manager = create :manager
      @employee.assign_to @manager

      leave_attrs = attributes_for :leave_request
      @leave_request = @employee.leave_requests.create leave_attrs
    end

    it "should approve request" do
      login(@manager)
      post "/members/#{@employee.id}/leave_requests/#{@leave_request.id}/processed", approved: true
      expect(response).to have_http_status 200
      @leave_request.reload
      expect(@leave_request.approved?).to be(true)
    end

    it "should reject request" do
      login(@manager)
      post "/members/#{@employee.id}/leave_requests/#{@leave_request.id}/processed", rejected: true
      expect(response).to have_http_status 200
      @leave_request.reload
      expect(@leave_request.rejected?).to be(true)
    end

    it "should 403 if not employee's manger" do
      login(@employee)
      post "/members/#{@employee.id}/leave_requests/#{@leave_request.id}/processed", rejected: true
      expect(response).to have_http_status 403
    end
  end
end
