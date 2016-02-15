class RuleConflictPolicy < ApplicationPolicy
  alias_attribute :rule_conflict, :record

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
    RulePolicy.new(user, rule_conflict.rule_1).update? && RulePolicy.new(user, rule_conflict.rule_2).update?
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
