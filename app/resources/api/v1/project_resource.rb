class Api::V1::ProjectResource < Api::V1::BaseResource
  attributes :name, :description

  has_many :memberships
  has_many :rule_conflicts
  has_many :rule_relationships

  after_create :create_current_user_membership

  private

  def create_current_user_membership
    Membership.create(project: @model, user: context[:user])
  end
end
