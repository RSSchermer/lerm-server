require 'rails_helper'

describe RuleConflict do
  subject(:rule_conflict) { FactoryGirl.build(:rule_conflict) }

  it 'should have a valid factory' do
    expect(rule_conflict).to be_valid
  end

  context 'without a rule_1' do
    before { rule_conflict.rule_1 = nil }

    it { expect(rule_conflict).to_not be_valid }
  end

  context 'without a rule_2' do
    before { rule_conflict.rule_2 = nil }

    it { expect(rule_conflict).to_not be_valid }
  end

  context 'without a description' do
    before { rule_conflict.description = nil }

    it { expect(rule_conflict).to_not be_valid }
  end
end
