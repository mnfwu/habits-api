json.extract! @habit, :name, :frequency_options, :steps_completed, :completed, :master_habit_id, :due_date, :completed_date, :completed_on_time, :total_steps
json.master_habit MasterHabit.find(@habit.master_habit_id)
json.steps Step.where("habit_id = #{@habit.id}")