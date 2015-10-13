class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.references :category, index: true
      t.string :description, null: false
      t.decimal :price

      t.timestamps null: false
    end
    add_foreign_key :products, :categories
  end
end
