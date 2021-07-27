@user = User.find(@master_habits.first.user_id)
json.user @user
json.master_habits @master_habits
json.groups @user.groups

# @goals = []
# @user.groups do |group|
#   @goal = Goal.where("group_id = #{group.id}")
#   @goals << @goal
# end

# json.goals @goals
# # @master_habits = MasterHabit.where("user_id = #{params[:user_id]}")
