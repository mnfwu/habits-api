class Habit < ApplicationRecord
  has_many :steps
  belongs_to :master_habit

  
end
