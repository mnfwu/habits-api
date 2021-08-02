class AddUserAverages < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :weekly_average, :integer, default: 0
  end
end
