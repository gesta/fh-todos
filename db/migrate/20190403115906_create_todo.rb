class CreateTodo < ActiveRecord::Migration[5.2]
  def change
    create_table :todos do |t|
      t.boolean :completed?, null: false, default: false
      t.string :content, null: false
      t.date :due_date, null: false
      t.integer :priority, null: false

      t.timestamps
    end
  end
end
