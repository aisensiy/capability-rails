require 'rails_helper'

RSpec.describe "Tags", type: :request do
  describe "create new tag" do
    it "should 403 without admin login" do
      employee = create :employee
      login employee
      post "/tags", tag: attributes_for(:tag)
      expect(response).to have_http_status(403)
    end

    it "create new tag with valide input" do
      admin = create :admin
      login admin
      post "/tags", tag: attributes_for(:tag)
      tag = Tag.last
      expect(response).to have_http_status(201)
      expect(response.headers['Location']).to end_with("/tags/#{tag.id}")
    end

    it 'should fail with invalid input' do
      admin = create :admin
      login admin
      post "/tags", tag: {name: 'bb'}
      expect(response).to have_http_status(400)
    end
  end

  describe "login" do
    it "should 400 if wrong password or username" do
      post "/tags/login", {name: "asdf", password: "ddd"}
      expect(response).to have_http_status(400)
    end
  end

  describe "logout" do
    it "should logout" do
      admin = create :admin
      post "/tags/login", {password: admin.password, name: admin.name}
      post "/tags/logout"
      expect(response).to have_http_status(200)
      post "/tags", tag: {name: 'bb'}
      expect(response).to have_http_status(401)
    end
  end

  describe "get one tag" do
    it "should get one tag" do
      tag = create :employee
      login(tag)
      get "/tags/#{tag.id}"
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data['name']).to eq(tag.name)
    end

    it "should 404" do
      tag = create :employee
      login(tag)
      get "/tags/1"
      expect(response).to have_http_status(404)
    end
  end

  describe "list tags" do
    it "should list tags" do
      5.times do |i|
        create :employee, name: "name_#{i}"
      end
      tag = create :employee
      login(tag)
      get "/tags"
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data.size).to eq(6)
      first = data[0]
      expect(first["name"]).to eq("name_0")
    end
  end

end
