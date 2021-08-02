@user = User.find(@master_habits.first.user_id)
json.user @user
json.master_habits do
	json.array! @master_habits do |master_habit|
		json.extract! master_habit, :id, :name, :frequency_options, :start_date, :end_date, :user_id, :percent_complete
		json.habit Habit.where("master_habit_id = #{master_habit.id}").order("due_date")
	end
end
json.groups @user.groups

@date = Date.today