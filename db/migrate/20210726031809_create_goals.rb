class CreateGoals < ActiveRecord::Migration[6.0]
  def change
    create_table :goals do |t|
      t.integer :percent_complete
      t.date :end_date

      t.timestamps
    end
  end
end
