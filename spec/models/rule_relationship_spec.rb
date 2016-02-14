require 'rails_helper'

describe RuleRelationship do
  subject(:rule_relationship) { FactoryGirl.build(:rule_relationship) }

  it 'should have a valid factory' do
    expect(rule_relationship).to be_valid
  end

  context 'without a rule_1' do
    before { rule_relationship.rule_1 = nil }

    it { expect(rule_relationship).to_not be_valid }
  end

  context 'without a rule_2' do
    before { rule_relationship.rule_2 = nil }

    it { expect(rule_relationship).to_not be_valid }
  end

  context 'without a description' do
    before { rule_relationship.description = nil }

    it { expect(rule_relationship).to_not be_valid }
  end
end
