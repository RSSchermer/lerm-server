class CreatePhrases < ActiveRecord::Migration
  def change
    create_table :phrases do |t|
      t.string :text, null: false
      t.string :clean_text
      t.boolean :discarded
      t.boolean :crisp
      t.text :data_element_expression
      t.references :rule, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
