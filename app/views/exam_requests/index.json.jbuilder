json.array!(@exam_requests) do |exam_request|
  json.extract! exam_request, :id, :status, :created_at, :updated_at, :exam_time
  json.url member_exam_request_url(@member, exam_request)
  json.tag do
    json.extract! exam_request.tag, :name, :id
    json.url tag_url(exam_request.tag)
  end
end
