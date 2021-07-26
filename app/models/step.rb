class Step < ApplicationRecord
  belongs_to :habit
  validates :name, presence: true
end
