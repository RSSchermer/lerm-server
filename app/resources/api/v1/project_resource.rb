class Api::V1::ProjectResource < Api::V1::BaseResource
  attributes :name, :description, :rule_id

  has_many :memberships

  after_create :create_current_user_membership

  private

  def create_current_user_membership
    Membership.create(project: @model, user: context[:user])
  end
end
