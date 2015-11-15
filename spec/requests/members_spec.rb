require 'rails_helper'

RSpec.describe "Members", type: :request do
  describe "create new member" do
    it "should 403 without admin login" do
      employee = create :employee
      post "/members/login", {password: employee.password, name: employee.name}
      post "/members", member: {name: 'abc', password: 'bb', role: 'employee'}
      expect(response).to have_http_status(403)
    end

    it "create new member with valide input" do
      admin = create :admin
      post "/members/login", {password: admin.password, name: admin.name}
      post "/members", member: {name: 'abc', password: 'bb', role: 'employee'}
      member = Member.order_by(created_at: :desc).first
      expect(response).to have_http_status(201)
      expect(response.headers['Location']).to end_with("/members/#{member.id}")
    end

    it 'should fail with invalid input' do
      admin = create :admin
      post "/members/login", {password: admin.password, name: admin.name}
      post "/members", member: {name: 'bb'}
      expect(response).to have_http_status(400)
    end
  end

  describe "login" do
    it "should 400 if wrong password or username" do
      post "/members/login", {name: "asdf", password: "ddd"}
      expect(response).to have_http_status(400)
    end
  end

  describe "logout" do
    it "should logout" do
      admin = create :admin
      post "/members/login", {password: admin.password, name: admin.name}
      post "/members/logout"
      expect(response).to have_http_status(200)
      post "/members", member: {name: 'bb'}
      expect(response).to have_http_status(401)
    end
  end

  describe "get one member" do
    it "should get one member" do
      member = create :employee
      login(member)
      get "/members/#{member.id}"
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data['name']).to eq(member.name)
    end

    it "should 404" do
      member = create :employee
      login(member)
      get "/members/1"
      expect(response).to have_http_status(404)
    end
  end

  describe "list members" do
    it "should list members" do
      5.times do |i|
        create :employee, name: "name_#{i}"
      end
      member = create :employee
      login(member)
      get "/members"
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data.size).to eq(6)
      first = data[0]
      expect(first["name"]).to eq("name_0")
    end
  end

  describe "assign employee to manager" do
    it "should assign employee to manager by admin" do
      manager = create :manager
      employee = create :employee
      admin = create :admin
      login admin

      post "/members/#{employee.id}/assigned", manager_id: manager.id
      expect(response).to have_http_status 200
      expect(employee.assign).to eq(manager)
    end

    it "should 403 without admin role" do
      manager = create :manager
      employee = create :employee
      login employee

      post "/members/#{employee.id}/assigned", manager_id: manager.id
      expect(response).to have_http_status 403
    end

    it "should 404 if member or team not found" do
      employee = create :employee
      admin = create :admin
      login admin

      post "/members/#{employee.id}/assigned", manager_id: 12
      expect(response).to have_http_status 404
    end
  end
end
