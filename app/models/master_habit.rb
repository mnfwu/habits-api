class MasterHabit < ApplicationRecord
	belongs_to :user
	validates :name, presence: true
	validates :frequency_options, presence: true
	validates :start_date, presence: true
end
