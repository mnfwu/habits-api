class AddWeeklyStatsToMasterHabit < ActiveRecord::Migration[6.0]
  def change
    add_column :master_habits, :percent_complete, :integer
  end
end
