json.master_habits do
  json.array! @master_habits do |master_habit|
    json.extract! master_habit, :id, :name, :percent_complete, :frequency_options, :start_date, :end_date, :user_id
  end
end
