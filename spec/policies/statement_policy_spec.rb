require 'rails_helper'

describe StatementPolicy do
  let(:project) { FactoryGirl.create(:project) }
  let(:rule) { FactoryGirl.create(:rule, project: project) }
  let(:statement) { FactoryGirl.create(:statement, rule: rule) }

  context 'unauthenticated user' do
    let(:user) { nil }
    subject(:policy) { StatementPolicy.new(user, statement) }

    describe 'index?' do
      it { expect(policy.index?).to be_truthy }
    end

    describe 'show?' do
      it { expect(policy.show?).to be_truthy }
    end

    describe 'create?' do
      it { expect(policy.create?).to be_falsey }
    end

    describe 'update?' do
      it { expect(policy.update?).to be_falsey }
    end

    describe 'destroy?' do
      it { expect(policy.destroy?).to be_falsey }
    end
  end

  context 'normal user that is not a project member' do
    let(:user) { FactoryGirl.create(:user) }
    subject(:policy) { StatementPolicy.new(user, statement) }

    describe 'index?' do
      it { expect(policy.index?).to be_truthy }
    end

    describe 'show?' do
      it { expect(policy.show?).to be_truthy }
    end

    describe 'create?' do
      it { expect(policy.create?).to be_truthy }
    end

    describe 'update?' do
      it { expect(policy.update?).to be_falsey }
    end

    describe 'destroy?' do
      it { expect(policy.destroy?).to be_falsey }
    end
  end

  context 'normal user that is a project member' do
    let(:user) { FactoryGirl.create(:user) }
    subject(:policy) { StatementPolicy.new(user, statement) }

    before { FactoryGirl.create(:membership, user: user, project: project)}

    describe 'index?' do
      it { expect(policy.index?).to be_truthy }
    end

    describe 'show?' do
      it { expect(policy.show?).to be_truthy }
    end

    describe 'create?' do
      it { expect(policy.create?).to be_truthy }
    end

    describe 'update?' do
      it { expect(policy.update?).to be_truthy }
    end

    describe 'destroy?' do
      it { expect(policy.destroy?).to be_truthy }
    end
  end

  context 'super admin user' do
    let(:user) { FactoryGirl.create(:super_admin) }
    subject(:policy) { StatementPolicy.new(user, statement) }

    describe 'index?' do
      it { expect(policy.index?).to be_truthy }
    end

    describe 'show?' do
      it { expect(policy.show?).to be_truthy }
    end

    describe 'create?' do
      it { expect(policy.create?).to be_truthy }
    end

    describe 'update?' do
      it { expect(policy.update?).to be_truthy }
    end

    describe 'destroy?' do
      it { expect(policy.destroy?).to be_truthy }
    end
  end
end