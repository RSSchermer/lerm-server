class Api::V1::RuleRelationshipResource < Api::V1::BaseResource
  attributes :description

  has_one :rule_1
  has_one :rule_2
  has_one :project
end
