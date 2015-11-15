json.array!(@exam_requests) do |exam_request|
  json.extract! exam_request, :id
  json.url exam_request_url(exam_request, format: :json)
end
