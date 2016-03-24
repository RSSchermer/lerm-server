require 'rails_helper'

describe Statement do
  let(:rule) { FactoryGirl.create(:rule) }
  subject(:statement) { FactoryGirl.build(:statement, rule: rule) }

  it 'should have a valid factory' do
    expect(statement).to be_valid
  end

  context 'without an original condition' do
    before { statement.original_condition = nil }

    it { expect(statement).to_not be_valid }
  end

  context 'without an original consequence' do
    before { statement.original_consequence = nil }

    it { expect(statement).to_not be_valid }
  end

  context 'without a rule' do
    before { statement.rule = nil }

    it { expect(statement).to_not be_valid }
  end
end
