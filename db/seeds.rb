require 'faker'

#Creating users
# puts "***Creating Users***"

# 10.times do
# 	user = User.new(
# 		open_id: rand(0..10),
# 		display_name: Faker::Creature::Animal.name
# 		)
# 	user.save!
# 	puts "User: #{user.display_name} created!"
# end

#Creating habits
# puts "***Creating MasterHabits***"
# i = 10
# 10.times do
# 	habits = ["sleep routine", "workout routine", "morning routine", "mindfulness"]
# 	frequency = [["Monday", "Wednesday", "Friday"], ["4 times a week"], ["2 times a week"], ["Tuesday", "Friday"]]
# 	master_habit = MasterHabit.new(
# 		user_id: User.all.sample.id,
# 		name: habits.sample,
# 		frequency_options: frequency.sample,
# 		start_date: Date.today,
# 		end_date: Date.today + i
# 		)
# 	master_habit.save!
# 	i += 1
# 	puts "Master Habit: #{master_habit.name} created!"
# end

puts "***Creating Habits***"
20.times do
	habit = Habit.new(
		master_habit_id: MasterHabit.all.sample.id,
		partially_completed: 0,
		completed: 0
		)
	habit.save!
	puts "Habit created!"
end

puts "***Creating Steps"
30.times do
	names = ["Drink water", "Walk for 10 minutes", "Meditate for 10 minutes", "Clean room", "Stretch", "Skincare"]
	step = Step.new(
		habit_id: Habit.all.sample.id,
		name: names.sample,
		step_type: "checkbox",
		completed: false
		)
	step.save!
	puts "Step: #{step.name} created!"
end

#Creating groups
# 3.times do
# 	group_name = ["Xuhui's Finest", "Coding Buddies", "Habits App Group"]
# 	group = Group.new(
# 		name: group_name.sample
# 		)
# 	group.save!
# 	puts "Group: #{group.name} created!"
# end

# 15.times do 
# 	user_group = UsersGroup.new(
# 		user_id: User.all.sample.id,
# 		group_id: Group.all.sample.id
# 		)
# 	user_group.save!
# 	puts "User Group created!"
# end


