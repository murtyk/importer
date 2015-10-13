class CreateImportStatuses < ActiveRecord::Migration
  def change
    create_table :import_statuses do |t|
      t.string :type, null: false
      t.integer :status, default: 0
      t.string :file_name
      t.text :success_ids, array: true, default: []
      t.hstore :data

      t.timestamps null: false
    end
  end
end
