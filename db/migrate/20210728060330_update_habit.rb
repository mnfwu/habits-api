class UpdateHabit < ActiveRecord::Migration[6.0]
  def change
    add_column :habits, :due_date, :date
    add_column :habits, :completed_date, :date
    add_column :habits, :completed_on_time?, :boolean
    remove_column :habits, :completed, :integer
    add_column :habits, :completed?, :boolean
  end
end
