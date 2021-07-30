json.extract! @master_habit, :id, :name, :frequency_options, :percent_complete, :start_date, :end_date, :user_id
json.habits Habit.where("master_habit_id = #{@master_habit.id}").order("due_date")