require 'rails_helper'

describe Project do
  let(:rule) { FactoryGirl.create(:rule) }
  subject(:statement) { FactoryGirl.build(:statement, rule: rule) }

  it 'should have a valid factory' do
    expect(statement).to be_valid
  end

  context 'without a condition' do
    before { statement.condition = nil }

    it { expect(statement).to_not be_valid }
  end

  context 'without a consequence' do
    before { statement.consequence = nil }

    it { expect(statement).to_not be_valid }
  end

  context 'without a rule' do
    before { statement.rule = nil }

    it { expect(statement).to_not be_valid }
  end
end
