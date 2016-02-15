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
    RulePolicy.new(user, rule_relationship.rule_1).update? && RulePolicy.new(user, rule_relationship.rule_2).update?
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
