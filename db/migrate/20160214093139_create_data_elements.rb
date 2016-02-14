class CreateDataElements < ActiveRecord::Migration
  def change
    create_table :data_elements do |t|
      t.string :label, index: true, null: false
      t.text :description
      t.references :project, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
