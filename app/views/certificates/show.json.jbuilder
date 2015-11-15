json.extract! @certificate, :id, :created_at, :updated_at
json.tag do
  json.extract! @tag, :id, :name
  json.url tag_url(@tag)
end
json.exam do
  json.extract! @exam, :id, :exam_time
  json.url member_exam_request_url(@member, @exam)
end
