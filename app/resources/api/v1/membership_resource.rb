class Api::V1::MembershipResource < Api::V1::BaseResource
  attributes :user_id, :project_id

  has_one :user
  has_one :project

  before_create :authorize_create

  private

  def authorize_create
    raise Pundit::NotAuthorizedError unless ProjectPolicy.new(context[:user], @model.project).update?
  end
end
