class UpdateHabitCompletedName < ActiveRecord::Migration[6.0]
  def change
    rename_column :habits, :partially_completed, :steps_completed
  end
end
