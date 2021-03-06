json.extract! @user, :id, :open_id, :wechat_username, :wechat_pic_url, :weekly_average
json.master_habits do
	json.array! @master_habits do |master_habit|
		json.extract! master_habit, :id, :name, :frequency_options, :start_date, :end_date, :user_id, :percent_complete
		json.habit Habit.where("master_habit_id = #{master_habit.id}").order("due_date")
	end
end
json.groups do
	json.array! @user.groups do |group|
		json.extract! group, :id, :name
		json.group_users group.users
	end
end
