require 'rails_helper'

describe RuleRelationship do
  subject(:rule_relationship) { FactoryGirl.build(:rule_relationship) }

  it 'should have a valid factory' do
    expect(rule_relationship).to be_valid
  end

  context 'without a rule_one' do
    before { rule_relationship.rule_one = nil }

    it { expect(rule_relationship).to_not be_valid }
  end

  context 'without a rule_two' do
    before { rule_relationship.rule_two = nil }

    it { expect(rule_relationship).to_not be_valid }
  end

  context 'without a description' do
    before { rule_relationship.description = nil }

    it { expect(rule_relationship).to_not be_valid }
  end

  context 'without a project' do
    before { rule_relationship.project = nil }

    it { expect(rule_relationship).to_not be_valid }
  end
end
