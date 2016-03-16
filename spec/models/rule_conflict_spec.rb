require 'rails_helper'

describe RuleConflict do
  subject(:rule_conflict) { FactoryGirl.build(:rule_conflict) }

  it 'should have a valid factory' do
    expect(rule_conflict).to be_valid
  end

  context 'without a rule_one' do
    before { rule_conflict.rule_one = nil }

    it { expect(rule_conflict).to_not be_valid }
  end

  context 'without a rule_two' do
    before { rule_conflict.rule_two = nil }

    it { expect(rule_conflict).to_not be_valid }
  end

  context 'without a description' do
    before { rule_conflict.description = nil }

    it { expect(rule_conflict).to_not be_valid }
  end

  context 'without a project' do
    before { rule_conflict.project = nil }

    it { expect(rule_conflict).to_not be_valid }
  end
end
