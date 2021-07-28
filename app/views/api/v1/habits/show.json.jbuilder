json.extract! @habit, :steps_completed, :completed?, :master_habit_id, :due_date, :completed_date, :completed_on_time?
json.master_habit MasterHabit.find(@habit.master_habit_id)
json.steps Step.where("habit_id = #{@habit.id}")