class CreateMasterHabits < ActiveRecord::Migration[6.0]
  def change
    create_table :master_habits do |t|
      t.string :name
      t.text :frequency_options, array: true, default: []
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
