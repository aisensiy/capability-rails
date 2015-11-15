require 'rails_helper'

RSpec.describe LeaveRequest, type: :model do
  it "should create new request" do
    member = create :employee
    request_attrs = attributes_for :leave_request
    request = member.leave_requests.create(request_attrs)
    expect(request.status).to eq(:created)
  end
end
