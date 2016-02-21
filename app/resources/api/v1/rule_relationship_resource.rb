class Api::V1::RuleRelationshipResource < Api::V1::BaseResource
  attributes :description, :rule_1_id, :rule_2_id, :project_id

  has_one :rule_1
  has_one :rule_2
  has_one :project
end
