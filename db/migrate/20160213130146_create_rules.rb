class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.string :label, index: true, null: false
      t.string :source
      t.text :original_text
      t.text :proactive_form
      t.integer :formalization_status, default: 0
      t.references :project, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
