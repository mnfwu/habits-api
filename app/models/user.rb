class User < ApplicationRecord
	has_many :master_habits
	has_many :users_groups
end
