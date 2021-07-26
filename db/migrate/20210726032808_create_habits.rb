class CreateHabits < ActiveRecord::Migration[6.0]
  def change
    create_table :habits do |t|
      t.integer :partially_completed
      t.integer :completed
      t.references :master_habit, null: false, foreign_key: true

      t.timestamps
    end
  end
end
