require 'rails_helper'

describe Rule do
  let(:project) { FactoryGirl.create(:project) }
  subject(:rule) { FactoryGirl.build(:rule, project: project) }

  it 'should have a valid factory' do
    expect(rule).to be_valid
  end

  context 'without name' do
    before { rule.label = nil }

    it { expect(rule).to_not be_valid }
  end

  context 'with a non-unique name within a project' do
    let(:other_rule) { FactoryGirl.create(:rule, project: project) }

    before { rule.label = other_rule.label }

    it { expect(rule).to_not be_valid }
  end

  context 'with a non-unique global name, but unique within a project' do
    let(:other_project) { FactoryGirl.create(:project) }
    let(:other_rule) { FactoryGirl.create(:rule, project: other_project) }

    before { rule.label = other_rule.label }

    it { expect(rule).to be_valid }
  end

  context 'without an original text' do
    before { rule.original_text = nil }

    it { expect(rule).to_not be_valid }
  end

  context 'without a project' do
    before { rule.project = nil }

    it { expect(rule).to_not be_valid }
  end

  describe 'rule_conflicts' do
    subject(:rule) { FactoryGirl.create(:rule, project: project) }
    let(:other_rule) { FactoryGirl.create(:rule, project: project) }

    context 'with outgoing conflicts' do
      let!(:outgoing_conflict) { FactoryGirl.create(:rule_conflict, rule_one: rule, rule_two: other_rule) }

      it { expect(rule.rule_conflicts).to contain_exactly(outgoing_conflict)}
    end

    context 'with incoming conflicts' do
      let!(:incoming_conflict) { FactoryGirl.create(:rule_conflict, rule_one: other_rule, rule_two: rule) }

      it { expect(rule.rule_conflicts).to contain_exactly(incoming_conflict)}
    end

    context 'with incoming and outgoing conflicts' do
      let!(:outgoing_conflict) { FactoryGirl.create(:rule_conflict, rule_one: rule, rule_two: other_rule) }
      let!(:incoming_conflict) { FactoryGirl.create(:rule_conflict, rule_one: other_rule, rule_two: rule) }

      it { expect(rule.rule_conflicts).to contain_exactly(outgoing_conflict, incoming_conflict)}
    end
  end

  describe 'rule_relationships' do
    subject(:rule) { FactoryGirl.create(:rule, project: project) }
    let(:other_rule) { FactoryGirl.create(:rule, project: project) }

    context 'with outgoing relationships' do
      let!(:outgoing_relationship) { FactoryGirl.create(:rule_relationship, rule_one: rule, rule_two: other_rule) }

      it { expect(rule.rule_relationships).to contain_exactly(outgoing_relationship)}
    end

    context 'with incoming relationships' do
      let!(:incoming_relationship) { FactoryGirl.create(:rule_relationship, rule_one: other_rule, rule_two: rule) }

      it { expect(rule.rule_relationships).to contain_exactly(incoming_relationship)}
    end

    context 'with incoming and outgoing relationships' do
      let!(:outgoing_relationship) { FactoryGirl.create(:rule_relationship, rule_one: rule, rule_two: other_rule) }
      let!(:incoming_relationship) { FactoryGirl.create(:rule_relationship, rule_one: other_rule, rule_two: rule) }

      it { expect(rule.rule_relationships).to contain_exactly(outgoing_relationship, incoming_relationship)}
    end
  end
end