json.extract! @exam_request, :id, :created_at, :updated_at, :exam_time, :statuse
json.tag do
  json.extract! @exam_request.tag, :name, :id
  json.url tag_url(@exam_request.tag)
end
