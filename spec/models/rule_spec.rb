require 'rails_helper'

describe Project do
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
end