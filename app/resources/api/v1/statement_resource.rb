class Api::V1::StatementResource < Api::V1::BaseResource
  attributes :condition, :consequence, :cleaned_condition, :cleaned_consequence, :discarded

  has_one :rule

  before_create :authorize_create

  private

  def authorize_create
    raise Pundit::NotAuthorizedError unless RulePolicy.new(context[:user], @model.rule).update?
  end
end
