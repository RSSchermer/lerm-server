class CreateStatements < ActiveRecord::Migration
  def change
    create_table :statements do |t|
      t.text :original_condition, null: false
      t.text :original_consequence, null: false
      t.text :cleaned_condition
      t.text :cleaned_consequence
      t.boolean :discarded, default: false
      t.references :rule, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
