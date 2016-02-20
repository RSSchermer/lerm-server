class Api::V1::DataElementResource < Api::V1::BaseResource
  attributes :label, :description, :project_id

  has_one :project
  has_many :phrases
  has_many :rules

  before_create :authorize_create

  private

  def authorize_create
    raise Pundit::NotAuthorizedError unless ProjectPolicy.new(context[:user], @model.project).update?
  end
end
