json.extract! @step, :name, :step_type, :completed, :habit_id
json.habit Habit.find(@step.habit_id)
