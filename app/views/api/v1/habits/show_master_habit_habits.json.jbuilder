# json.habits do
#   json.array! @habits do |habit|
#     json.extract! habit, :partially_completed, :completed, :master_habit_id
#     json.user MasterHabit.find(habit.master_habit_id)
#   end
# end

#moved to master_habits/show