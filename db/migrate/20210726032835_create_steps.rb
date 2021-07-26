class CreateSteps < ActiveRecord::Migration[6.0]
  def change
    create_table :steps do |t|
      t.references :habit, null: false, foreign_key: true
      t.string :name
      t.string :type
      t.boolean :completed

      t.timestamps
    end
  end
end
