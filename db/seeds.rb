require 'faker'

#Creating users
puts "***Creating Users***"

10.times do
	user = User.new(
		open_id: rand(0..10),
		display_name: Faker::Creature::Animal.name
		)
	user.save!
	puts "User: #{user.display_name} created!"
end

#Creating habits
puts "***Creating MasterHabits***"
10.times do
	habits = ["sleep routine", "workout routine", "morning routine", "mindfulness"]
	frequency = [["Monday", "Wednesday", "Friday"], "4 times a week", "2 times a week", ["Tueday", "Friday"]]
	master_habit = MasterHabit.new(
		user_id: User.all.sample.id,
		name: habits.sample,
		frequency: frequency.sample,
		start_date: ,
		end_date:
		)
	master_habit.save!
	puts "Master Habit: #{master_habit.name} created!"
end

puts "***Creating Habits***"
10.times do
	habit = Habit.new (
		master_habit_id: Masterhabit.all.sample.id,
		partially_completed: 0 ,
		completed: 0
		)
	habit.save!
	puts "Habit created!"
end

puts "***Creating Steps"
10.times do
	step = Step.new(
		habit_id: Habit.all.sample.id,
		name: ,
		type: ,
		completed: false
		)
	step.save!
	puts "Step: #{step.name} created!"
end

#Creating groups
3.times do
	group_name = ["Xuhui's Finest", "Shanghai"]
	group = Group.new(
		name: 
		)
