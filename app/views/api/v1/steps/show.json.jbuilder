json.extract! @step, :name, :step_type, :completed, :habit_id
json.user Habit.find(@step.habit_id)
