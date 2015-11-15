json.extract! @leave_conflict, :id, :created_at, :updated_at, :leave_request_id, :timecard_id
json.timecard do
  json.extract! @leave_conflict.timecard, :id, :date, :hour
  json.url member_timecard_url(@member, @leave_conflict.timecard)
end
json.leave_request do
  json.extract! @leave_conflict.leave_request, :id, :from, :to, :title, :status
  json.url member_timecard_url(@member, @leave_conflict.leave_request)
end
