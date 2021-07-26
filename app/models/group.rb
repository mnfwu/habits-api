class Group < ApplicationRecord
	has_many :goals
	has_many :users_groups
end
