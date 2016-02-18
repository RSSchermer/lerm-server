require 'rails_helper'

describe MembershipPolicy do
  let(:project) { FactoryGirl.create(:project) }
  let(:user) { FactoryGirl.create(:user) }
  let(:membership) { FactoryGirl.create(:membership, user: user, project: project) }

  context 'unauthenticated user' do
    let(:current_user) { nil }
    subject(:policy) { MembershipPolicy.new(current_user, membership) }

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
    let(:current_user) { FactoryGirl.create(:user) }
    subject(:policy) { MembershipPolicy.new(current_user, membership) }

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
    let(:current_user) { FactoryGirl.create(:user) }
    subject(:policy) { MembershipPolicy.new(current_user, membership) }

    before { FactoryGirl.create(:membership, user: current_user, project: project)}

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
    let(:current_user) { FactoryGirl.create(:super_admin) }
    subject(:policy) { MembershipPolicy.new(current_user, membership) }

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