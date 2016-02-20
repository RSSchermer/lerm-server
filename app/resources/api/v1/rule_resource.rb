class Api::V1::RuleResource < Api::V1::BaseResource
  attributes :label, :source, :original_text, :proactive_form

  has_one :project
  has_many :phrases
  has_many :statements
  has_many :rule_conflicts
  has_many :rule_relationships

  before_create :authorize_create

  private

  def authorize_create
    raise Pundit::NotAuthorizedError unless ProjectPolicy.new(context[:user], @model.project).update?
  end
end
