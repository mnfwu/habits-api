json.groups do
  json.array! @groups do |group|
    json.extract! group, :name
  end
end
