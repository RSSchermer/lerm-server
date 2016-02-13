class CreateRuleConflicts < ActiveRecord::Migration
  def change
    create_table :rule_conflicts do |t|
      t.integer :rule_1_id, index: true
      t.integer :rule_2_id, index: true
      t.text :description

      t.timestamps null: false
    end

    add_foreign_key :rule_conflicts, :rules, column: :rule_1_id
    add_foreign_key :rule_conflicts, :rules, column: :rule_2_id
  end
end
