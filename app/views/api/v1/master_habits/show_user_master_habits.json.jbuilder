json.master_habits do
  json.array! @master_habits do |master_habit|
    json.extract! master_habit, :name, :frequency_options, :start_date, :end_date, :user_id
    json.user User.find(master_habit.user_id)
  end
end
