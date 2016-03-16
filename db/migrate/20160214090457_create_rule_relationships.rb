class CreateRuleRelationships < ActiveRecord::Migration
  def change
    create_table :rule_relationships do |t|
      t.integer :rule_one_id, index: true, null: false
      t.integer :rule_two_id, index: true, null: false
      t.text :description
      t.references :project, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end

    add_foreign_key :rule_relationships, :rules, column: :rule_one_id
    add_foreign_key :rule_relationships, :rules, column: :rule_two_id
  end
end
