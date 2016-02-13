class Rule < ActiveRecord::Base
  default_scope { order(:label) }

  belongs_to :project
  has_many :phrases, dependent: :destroy
  has_many :statements, dependent: :destroy
  has_many :outgoing_rule_conflicts, class_name: 'RuleConflict', foreign_key: :rule_1_id, dependent: :destroy
  has_many :incoming_rule_conflicts, class_name: 'RuleConflict', foreign_key: :rule_2_id, dependent: :destroy

  validates :label, presence: true, uniqueness: { scope: :project }
  validates :original_text, presence: true
  validates :project_id, presence: true

  def rule_conflicts
    incoming_rule_conflicts + outgoing_rule_conflicts
  end
end
