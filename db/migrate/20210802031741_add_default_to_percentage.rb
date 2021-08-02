class AddDefaultToPercentage < ActiveRecord::Migration[6.0]
  def change
    change_column_default :master_habits, :percent_complete, 0
    change_column_default :habits, :weekly_percent_complete, 0
  end
end
