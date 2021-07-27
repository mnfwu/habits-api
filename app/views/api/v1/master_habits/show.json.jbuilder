json.extract! @master_habit, :id, :name, :frequency_options, :start_date, :end_date, :user_id
json.habits Habit.where("master_habit_id = #{@master_habit.id}")