class Api::V1::RuleRelationshipResource < Api::V1::BaseResource
  attributes :description

  has_one :rule_one
  has_one :rule_two
  has_one :project
end
