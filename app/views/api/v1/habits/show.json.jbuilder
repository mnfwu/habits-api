json.extract! @habit, :partially_completed, :completed, :master_habit_id
json.master_habit MasterHabit.find(@habit.master_habit_id)
json.steps Step.where("habit_id = #{@habit.id}")