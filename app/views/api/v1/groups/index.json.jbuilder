# For dev testing, view not for users
json.groups do
  json.array! @groups do |group|
    json.extract! group, :id, :name
    json.users group.users
  end
end
