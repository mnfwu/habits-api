class AddWeeklyCompletionToHabit < ActiveRecord::Migration[6.0]
  def change
    add_column :habits, :weekly_percent_complete, :integer
  end
end
