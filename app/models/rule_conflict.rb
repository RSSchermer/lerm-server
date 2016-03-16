class RuleConflict < ActiveRecord::Base
  belongs_to :rule_one, class_name: 'Rule'
  belongs_to :rule_two, class_name: 'Rule'
  belongs_to :project

  validates :rule_one_id, presence: true
  validates :rule_two_id, presence: true
  validates :description, presence: true
  validates :project_id, presence: true
end
