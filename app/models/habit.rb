class Habit < ApplicationRecord
  has_many :steps, :dependent => :destroy
  belongs_to :master_habit
end
