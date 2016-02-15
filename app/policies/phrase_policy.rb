class PhrasePolicy < ApplicationPolicy
  alias_attribute :phrase, :record

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
    RulePolicy.new(user, phrase.rule).update?
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
