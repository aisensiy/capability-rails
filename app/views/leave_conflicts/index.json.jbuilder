json.array!(@leave_conflicts) do |leave_conflict|
  json.extract! leave_conflict, :id
  json.url member_leave_conflict_url(@member, leave_conflict)
  json.timecard do
    json.extract! leave_conflict.timecard, :id, :date, :hour
    json.url member_timecard_url(@member, leave_conflict.timecard)
  end
  json.leave_request do
    json.extract! leave_conflict.leave_request, :id, :from, :to, :title, :status
    json.url member_timecard_url(@member, leave_conflict.leave_request)
  end
end
