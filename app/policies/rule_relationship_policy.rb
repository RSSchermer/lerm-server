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
    !user.nil? && (user.super_admin? || user.project_member?(rule_relationship.rule_1.project_id))
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
