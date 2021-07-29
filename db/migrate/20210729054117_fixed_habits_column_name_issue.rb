class FixedHabitsColumnNameIssue < ActiveRecord::Migration[6.0]
  def change
    rename_column :habits, :completed?, :completed
    rename_column :habits, :completed_on_time?, :completed_on_time
  end
end
