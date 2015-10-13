class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :code, null: false
      t.string :description

      t.timestamps null: false
    end
    add_index :categories, :code, unique: true
  end
end
