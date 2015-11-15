json.array!(@leave_requests) do |leave_request|
  json.extract! leave_request, :id, :title, :from, :to, :status
  json.url member_leave_request_url(@member, leave_request)
end
