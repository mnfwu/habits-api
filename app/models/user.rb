class User < ApplicationRecord
	has_many :master_habits
	has_many :users_groups
	validates :display_name, presence: true
end
