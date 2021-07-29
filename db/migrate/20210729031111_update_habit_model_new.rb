class UpdateHabitModelNew < ActiveRecord::Migration[6.0]
  def change
    add_column :habits, :name, :string
    add_column :habits, :frequency_options, :text, default: [], array: true
    add_column :habits, :total_steps, :integer, default: 0
    change_column_default :habits, :steps_completed, 0
  end
end
