class CreateStatements < ActiveRecord::Migration
  def change
    create_table :statements do |t|
      t.text :condition
      t.text :consequence
      t.text :cleaned_condition
      t.text :cleaned_consequence
      t.boolean :discarded, default: false
      t.references :rule, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
