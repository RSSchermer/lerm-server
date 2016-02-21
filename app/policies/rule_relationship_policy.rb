class RuleRelationshipPolicy < ApplicationPolicy
  alias_attribute :rule_relationship, :record

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
    ProjectPolicy.new(user, rule_relationship.project).update?
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
