class MembershipPolicy < ApplicationPolicy
  alias_attribute :membership, :record

  def index?
    true
  end

  def show?
    true
  end

  def create?
    !user.nil?
  end

  def new?
    create?
  end

  def manage?
    !user.nil? && ProjectPolicy.new(user, membership.project).update?
  end

  def update?
    manage?
  end

  def edit?
    update?
  end

  def destroy?
    manage?
  end
end
