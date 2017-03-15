class Project < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user
  has_many :rules, dependent: :destroy
  has_many :data_elements, dependent: :destroy
  has_many :rule_conflicts, dependent: :destroy
  has_many :rule_relationships, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def clone_for(user, clone_name)
    project = Project.includes([
        :data_elements,
        :rule_conflicts,
        :rule_relationships,
        rules: [:statements, :phrases]
    ]).find(id)

    cloned_project = project.dup
    cloned_project.name = clone_name

    transaction do
      cloned_project.save!

      cloned_data_elements = {}

      project.data_elements.each do |data_element|
        cloned_data_element = data_element.dup
        cloned_data_element.project = cloned_project
        cloned_data_element.save!
        cloned_data_elements[data_element.id] = cloned_data_element
      end

      cloned_rules = {}

      project.rules.each do |rule|
        cloned_rule = rule.dup
        cloned_rule.project = cloned_project
        cloned_rule.save!
        cloned_rules[rule.id] = cloned_rule

        rule.statements.each do |statement|
          cloned_statement = statement.dup
          cloned_statement.rule = cloned_rule
          cloned_statement.save!
        end

        rule.phrases.each do |phrase|
          cloned_phrase = phrase.dup
          cloned_phrase.rule = cloned_rule
          cloned_phrase.save!

          phrase.data_elements.each do |data_element|
            cloned_phrase.data_elements << cloned_data_elements[data_element.id]
          end
        end
      end

      project.rule_conflicts.each do |rule_conflict|
        cloned_rule_conflict = rule_conflict.dup
        cloned_rule_conflict.project = cloned_project
        cloned_rule_conflict.rule_one = cloned_rules[rule_conflict.rule_one_id]
        cloned_rule_conflict.rule_two = cloned_rules[rule_conflict.rule_two_id]
        cloned_rule_conflict.save!
      end

      project.rule_relationships.each do |rule_relationship|
        cloned_rule_relationship = rule_relationship.dup
        cloned_rule_relationship.project = cloned_project
        cloned_rule_relationship.rule_one = cloned_rules[rule_relationship.rule_one_id]
        cloned_rule_relationship.rule_two = cloned_rules[rule_relationship.rule_two_id]
        cloned_rule_relationship.save!
      end
    end

    Membership.create(project: cloned_project, user: user)

    cloned_project
  end
end
