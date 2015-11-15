require 'rails_helper'

RSpec.describe "Timecards", type: :request do
  before(:each) do
    @employee = create :employee
    timecard_attrs = attributes_for :timecard
    @timecard = @employee.timecards.create timecard_attrs
  end

  describe "create new timecard" do
    it "should 403 without system login" do
      employee2 = create :employee, name: 'two'
      timecard_attrs = attributes_for :timecard
      login employee2
      post "/members/#{@employee.id}/timecards", timecard: timecard_attrs
      expect(response).to have_http_status(403)
    end

    it "create new timecard with valide input" do
      timecard_attrs = attributes_for :timecard
      system = create :system
      login system
      post "/members/#{@employee.id}/timecards", timecard: timecard_attrs
      timecard = @employee.reload.timecards.last
      expect(response).to have_http_status(201)
      expect(response.headers['Location']).to end_with("/members/#{@employee.id}/timecards/#{timecard.id}")
    end

    it 'should fail with invalid input' do
      system = create :system
      login system
      post "/members/#{@employee.id}/timecards", timecard: {'abc' => '123'}
      expect(response).to have_http_status(400)
    end
  end

  describe "get one timecard" do
    it "should get one timecard" do
      login(@employee)
      get "/members/#{@employee.id}/timecards/#{@timecard.id}"
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data['hour']).to eq(@timecard.hour)
      expect(data['date']).to eq(@timecard.date.to_s)
    end

    it "should 404" do
      login(@employee)
      get "/members/#{@employee.id}/timecards/123"
      expect(response).to have_http_status(404)
    end
  end

  describe "list timecards" do
    it "should list timecards" do
      5.times do |i|
        attrs = attributes_for :timecard, date: "2015-11-0#{i + 1}"
        @employee.timecards.create attrs
      end

      login(@employee)
      get "/members/#{@employee.id}/timecards"
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data.size).to eq(6)
      first = data[-1]
      expect(first["date"]).to eq("2015-11-05")
    end
  end

end
