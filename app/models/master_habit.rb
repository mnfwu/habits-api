class MasterHabit < ApplicationRecord
	belongs_to :user
	serialize :frequency_options, Array
end
