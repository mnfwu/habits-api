class AddWeekToHabit < ActiveRecord::Migration[6.0]
  def change
    add_column :habits, :week, :integer
  end
end
