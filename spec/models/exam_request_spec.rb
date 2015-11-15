require 'rails_helper'

RSpec.describe ExamRequest, type: :model do
  before :each do
    @member = create :employee
    @tag = create :tag
    @exam_papter = @tag.exam_papers.create attributes_for(:exam_paper)
    @request = @member.exam_requests.create(exam_time: Time.now + 1.days, tag_id: @tag.id)
  end

  it 'should create new exame_request with status created' do
    request = @member.exam_requests.create(exam_time: Time.now + 1.days, tag_id: @tag.id)
    expect(request.status).to eq("created")

    expect(@member.exam_requests.size).to eq(1)
  end

  it 'should update failed without invalid status' do
    result = @request.change_state 'abc'
    expect(result).to be(false)
  end

  it 'should not update status with is cancelled finished rejected' do
    @request.change_state(:rejected)
    result = @request.change_state(:confirmed)
    expect(result).to be(false)
  end

  it 'should not update status to started without exam paper' do
    result = @request.change_state(:started)
    expect(result).to be(false)
  end
end
