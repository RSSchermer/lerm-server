class Api::V1::PhraseResource < Api::V1::BaseResource
  attributes :text, :cleaned_text, :discarded, :crisp, :data_element_expression

  has_one :rule
  has_many :data_elements

  before_create :authorize_create

  private

  def authorize_create
    raise Pundit::NotAuthorizedError unless RulePolicy.new(context[:user], @model.rule).update?
  end
end
