class Project < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user
  has_many :rules, dependent: :destroy
  has_many :data_elements, dependent: :destroy
  has_many :rule_conflicts, dependent: :destroy
  has_many :rule_relationships, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def clone_deep(new_name)
    project = Project.includes([
        :data_elements,
        rule_conflicts: [:rule_one, :rule_two],
        rule_relationships: [:rule_one, :rule_two],
        rules: [:statements, phrases: [:data_elements]]
    ]).find(id)

    cloned_project = project.clone
    cloned_project.name = new_name

    transaction do
      cloned_project.save!

      cloned_data_elements = []

      project.data_elements.each do |data_element|
        cloned_data_element = data_element.clone
        cloned_data_element.project = cloned_project
        cloned_data_element.save!
        cloned_data_elements << cloned_data_element
      end

      cloned_rules = []

      project.rules.each do |rule|
        cloned_rule = rule.clone
        cloned_rule.project = cloned_project
        cloned_rule.save!
        cloned_rules << cloned_rule

        rule.statements.each do |statement|
          cloned_statement = statement.clone
          cloned_statement.rule = cloned_rule
          cloned_statement.save!
        end

        rule.phrases.each do |phrase|
          cloned_phrase = phrase.clone
          cloned_phrase.rule = cloned_rule
          cloned_phrase.save!

          phrase.data_elements.each do |data_element|
            cloned_phrase.data_elements << cloned_data_elements.select { |e| e.label == data_element.label }.first
          end
        end
      end

      project.rule_conflicts.each do |rule_conflict|
        cloned_rule_conflict = rule_conflict.clone
        cloned_rule_conflict.project = cloned_project
        cloned_rule_conflict.rule_one = cloned_rules.select { |r| r.label == rule_conflict.rule_one.label }.first
        cloned_rule_conflict.rule_two = cloned_rules.select { |r| r.label == rule_conflict.rule_two.label }.first
        cloned_rule_conflict.save!
      end

      project.rule_relationships.each do |rule_relationship|
        cloned_rule_relationship = rule_relationship.clone
        cloned_rule_relationship.project = cloned_project
        cloned_rule_relationship.rule_one = cloned_rules.select { |r| r.label == rule_relationship.rule_one.label }.first
        cloned_rule_relationship.rule_two = cloned_rules.select { |r| r.label == rule_relationship.rule_two.label }.first
        cloned_rule_relationship.save!
      end
    end

    cloned_project
  end
end
