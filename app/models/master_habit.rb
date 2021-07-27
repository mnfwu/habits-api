class MasterHabit < ApplicationRecord
	belongs_to :user
	has_many :habits, :dependent => :destroy
	validates :name, presence: true
	validates :frequency_options, presence: true
	validates :start_date, presence: true
end