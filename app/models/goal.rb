class Goal < ApplicationRecord
	validates :percent_complete, presence: true
	validates :end_date, presence: true
end
