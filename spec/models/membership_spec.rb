require 'rails_helper'

describe Membership do
  subject(:membership) { FactoryGirl.build(:membership) }

  it 'should have a valid factory' do
    expect(membership).to be_valid
  end

  context 'without a project' do
    before { membership.project = nil }

    it { expect(membership).to_not be_valid }
  end

  context 'without a user' do
    before { membership.user = nil }

    it { expect(membership).to_not be_valid }
  end
end
