class RuleConflict < ActiveRecord::Base
  belongs_to :rule_1, class_name: 'Rule'
  belongs_to :rule_2, class_name: 'Rule'

  validates :rule_1_id, presence: true
  validates :rule_2_id, presence: true
  validates :description, presence: true
end
