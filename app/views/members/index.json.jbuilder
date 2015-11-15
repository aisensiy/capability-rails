json.array!(@members) do |member|
  json.extract! member, :id, :name, :role
  json.url member_url(member)
end