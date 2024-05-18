class CreateEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :employees do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :department, index: true
      t.integer :salary

      t.timestamps
    end
    add_index :employees, :email, unique: true
  end
end
