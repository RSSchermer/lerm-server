class Api::V1::RuleRelationshipResource < Api::V1::BaseResource
  attribute :description

  has_one :rule_1
  has_one :rule_2

  before_create :authorize_create

  private

  def authorize_create
    raise Pundit::NotAuthorizedError unless RulePolicy.new(context[:user], @model.rule).update?
  end
end
