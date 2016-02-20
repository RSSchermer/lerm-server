class Api::V1::RuleConflictResource < Api::V1::BaseResource
  attributes :description, :rule_1_id, :rule_2_id

  has_one :rule_1
  has_one :rule_2

  before_create :authorize_create

  private

  def authorize_create
    raise Pundit::NotAuthorizedError unless RulePolicy.new(context[:user], @model.rule).update?
  end
end
