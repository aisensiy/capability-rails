json.array!(@certificates) do |certificate|
  json.extract! certificate, :id, :created_at
  json.url member_certificate_url(@member, certificate)
  json.tag do
    json.url tag_url(certificate.tag_id)
  end
  json.exam do
    json.url member_exam_request_url(@member, certificate.exam_id)
  end
end
