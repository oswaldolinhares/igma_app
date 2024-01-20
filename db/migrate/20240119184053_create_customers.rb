class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.string :name, null: false
      t.string :cpf, null: false
      t.date :date_of_birth, null: false

      t.timestamps
    end

    add_index :customers, :cpf, unique: true
  end
end
