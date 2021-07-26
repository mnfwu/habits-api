class AddArrayToMasterhabitsAndCleanup < ActiveRecord::Migration[6.0]
  def change
    add_reference :goals, :group, foreign_key: true
    add_reference :master_habits, :user, foreign_key: true
  end
end
