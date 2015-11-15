json.array!(@timecards) do |timecard|
  json.extract! timecard, :id, :date, :hour, :created_at
  json.url member_timecard_url(@member, timecard)
end
