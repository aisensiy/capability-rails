require 'rails_helper'

RSpec.describe "Certificates", type: :request do
  before(:each) do
    @admin = create :admin
    @employee = create :employee
    @tag = create :tag
    @exam_attr ={ exam_time: Time.now + 2.days, tag_id: @tag.id }
    @exam_request = @employee.exam_requests.create(@exam_attr)
    @exam_paper = @tag.exam_papers.create attributes_for(:exam_paper)

    @certificate_attrs = {exam_id: @exam_request.id, tag_id: @tag.id}
    @certificate = @employee.certificates.create @certificate_attrs
  end

  describe "create new certificate" do
    it "should 403 without admin login" do
      employee2 = create :employee, name: 'two'
      login employee2
      post "/members/#{@employee.id}/certificates", certificate: @certificate_attrs
      expect(response).to have_http_status(403)
    end

    it "create new certificate with valide input" do
      login @admin
      post "/members/#{@employee.id}/certificates", certificate: @certificate_attrs
      certificate = @employee.reload.certificates.last
      expect(response).to have_http_status(201)
      expect(response.headers['Location']).to end_with("/members/#{@employee.id}/certificates/#{certificate.id}")
    end

    it 'should fail with invalid input' do
      login @admin
      post "/members/#{@employee.id}/certificates", certificate: {'abc' => '123'}
      expect(response).to have_http_status(400)
    end
  end

  describe "get one certificate" do
    it "should get one certificate" do
      login(@employee)
      get "/members/#{@employee.id}/certificates/#{@certificate.id}"
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data['hour']).to eq(@certificate.hour)
      expect(data['date']).to eq(@certificate.date.to_s)
    end

    it "should 404" do
      login(@employee)
      get "/members/#{@employee.id}/certificates/123"
      expect(response).to have_http_status(404)
    end
  end

  describe "list certificates" do
    it "should list certificates" do
      5.times do |i|
        attrs = attributes_for :certificate, date: "2015-11-0#{i + 1}"
        @employee.certificates.create attrs
      end

      login(@employee)
      get "/members/#{@employee.id}/certificates"
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data.size).to eq(6)
      first = data[-1]
      expect(first["date"]).to eq("2015-11-05")
    end
  end
end
