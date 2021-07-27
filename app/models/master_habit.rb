class MasterHabit < ApplicationRecord
	# after_save :logic_route
	belongs_to :user
	has_many :habits, :dependent => :destroy
	validates :name, presence: true
	validates :frequency_options, presence: true
	validates :start_date, presence: true

	def logic_route
		@master_habit = self
		case @master_habit.frequency_options[0]
		when "Daily"
			@frequency = daily
		when "Weekly"
			@frequency = times_per_week
		else
			@frequency = specific_days
		end
		generate_habit_instances(@frequency)
	end

#different kinds of frequency functions
	def daily
		return 7
		# need to code in logic based on day of the week
	end

	def times_per_week
		case @master_habit.frequency_options[1]
		when "One"
			return 1
		when "Two"
			return 2
		when "Three"
			return 3
		when "Four"
			return 4
		when "Five"
			return 5
		else
			return 6
		end
		# need to code in logic based on day of the week
	end

	def specific_days
		return @master_habit.frequency_options.length
	end

	def generate_habit_instances(frequency)
		frequency.times do
			@habit = Habit.new(master_habit_id: @master_habit.id)
			@habit.save!
			create_steps
			@steps.each do |step|
				step.habit_id = @habit.id
				step.save!
			end
		end
	end

	def create_steps()
		@steps = []
		2.times do
			@step = Step.new(name: "test")
			@steps << @step
		end
		return @steps
	end
end

