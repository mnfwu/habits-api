class Goal < ApplicationRecord
	belongs_to :group
	validates :percent_complete, presence: true
	validates :end_date, presence: true
end
