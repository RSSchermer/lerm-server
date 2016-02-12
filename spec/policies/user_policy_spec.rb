require 'rails_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }

  context 'unauthenticated user' do
    let(:current_user) { nil }
    subject(:policy) { UserPolicy.new(current_user, user) }

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

  context 'current user is not user' do
    let(:current_user) { FactoryGirl.create(:user) }
    subject(:policy) { UserPolicy.new(current_user, user) }

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

  context 'current user is user' do
    let(:current_user) { user }
    subject(:policy) { UserPolicy.new(current_user, user) }

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

  context 'current user is super admin user' do
    let(:current_user) { FactoryGirl.create(:super_admin) }
    subject(:policy) { UserPolicy.new(current_user, user) }

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
