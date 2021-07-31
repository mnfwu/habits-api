json.extract! @habit, :name, :frequency_options, :total_steps, :steps_completed, :weekly_percent_complete, :completed, :partially_completed, :missed, :due_date, :week, :master_habit_id
json.master_habit MasterHabit.find(@habit.master_habit_id)
json.steps Step.where("habit_id = #{@habit.id}")
json.other_habits Habit.where("week = #{@habit.week}")