json.array!(@certificates) do |certificate|
  json.extract! certificate, :id
  json.url certificate_url(certificate, format: :json)
end
