class User < ApplicationRecord
	has_many :master_habits
	has_many :users_groups
	has_many :groups, through: :users_groups
	# validates :display_name, presence: true
end
