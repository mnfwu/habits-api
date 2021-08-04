class MasterHabit < ApplicationRecord
	belongs_to :user
	has_many :habits, :dependent => :destroy
	validates :name, presence: true
	validates :frequency_options, presence: true
	validates :start_date, presence: true
	validate :end_date_earlier_than_start_date, on: :create
	# validate :start_date_earlier_than_today, on: :create

	private

	def end_date_earlier_than_start_date
		if end_date < start_date
			errors.add(:end_date, "End date cannot be earlier than start date")
		end
	end

	def start_date_earlier_than_today
		if start_date < Date.today
			errors.add(:start_date, "Start date cannot be earlier than today")
		end
	end

end