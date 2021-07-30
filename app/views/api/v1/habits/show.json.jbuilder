json.extract! @habit, :name, :frequency_options, :total_steps, :steps_completed, :completed, :partially_completed, :missed, :due_date, :week, :master_habit_id
@mh = MasterHabit.find(@habit.master_habit_id)
json.master_habit @mh
json.steps Step.where("habit_id = #{@habit.id}")
@habits = Habit.where("master_habit_id = #{@mh.id}")
json.other_habits @habits.where("week = #{@habit.week}")