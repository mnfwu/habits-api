class AddMissedToHabit < ActiveRecord::Migration[6.0]
  def change
    add_column :habits, :missed, :boolean
    add_column :habits, :partially_completed, :boolean
  end
end
