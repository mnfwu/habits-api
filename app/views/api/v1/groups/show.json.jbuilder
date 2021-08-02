json.extract! @group, :id, :name
json.user @group.users
json.goal @group.goals