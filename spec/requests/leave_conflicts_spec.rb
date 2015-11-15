require 'rails_helper'

RSpec.describe "LeaveConflicts", type: :request do
  before(:each) do
    @employee = create :employee
    @timecard = @employee.timecards.create date: '2015-11-15', hour: 8
    @leave_request = @employee.leave_requests.create(
        from: '2015-11-15'.to_datetime,
        to: '2015-11-16'.to_datetime,
        title: 'annual leave')
    @leave_request.approved!

    # @leave_conflict = @employee.leave_conflicts.create(timecard_id: @timecard.id, leave_request_id: @leave_request.id)
  end

  describe "create new leave_conflict" do
    it "should 403 without system login" do
      employee2 = create :employee, name: 'two'
      login employee2
      post "/members/#{@employee.id}/leave_conflicts", leave_conflict: {timecard_id: @timecard.id, leave_request_id: @leave_request.id}
      expect(response).to have_http_status(403)
    end

    it "create new leave_conflict with valide input" do
      system = create :system
      login system
      post "/members/#{@employee.id}/leave_conflicts", leave_conflict: {timecard_id: @timecard.id, leave_request_id: @leave_request.id}
      leave_conflict = @employee.reload.leave_conflicts.last
      expect(response).to have_http_status(201)
      expect(response.headers['Location']).to end_with("/members/#{@employee.id}/leave_conflicts/#{leave_conflict.id}")
    end

    it 'should fail with invalid input' do
      system = create :system
      login system
      post "/members/#{@employee.id}/leave_conflicts", leave_conflict: {'abc' => '123'}
      expect(response).to have_http_status(400)
    end
  end

  describe "get one leave_conflict" do
    it "should get one leave_conflict" do
      @leave_conflict = @employee.leave_conflicts.create(timecard_id: @timecard.id,
                                                         leave_request_id: @leave_request.id)
      login(@employee)
      get "/members/#{@employee.id}/leave_conflicts/#{@leave_conflict.id}"
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data['leave_request_id']).to eq(@leave_conflict.leave_request_id)
      expect(data['timecard_id']).to eq(@leave_conflict.timecard_id)
    end

    it "should 404" do
      login(@employee)
      get "/members/#{@employee.id}/leave_conflicts/123"
      expect(response).to have_http_status(404)
    end
  end

  describe "list leave_conflicts" do
    it "should list leave_conflicts" do
      5.times do |i|
        @employee.leave_conflicts.create(timecard_id: @timecard.id,
                                         leave_request_id: @leave_request.id)
      end

      login(@employee)
      get "/members/#{@employee.id}/leave_conflicts"
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data.size).to eq(5)
      first = data[-1]
      expect(first["timecard"]["date"].to_datetime).to eq(@timecard.date)
    end
  end
end
