require 'rails_helper'

describe User do
  subject(:user) { FactoryGirl.build(:user) }

  it 'should have a valid factory' do
    expect(user).to be_valid
  end

  context 'without a username' do
    before { user.username = nil }

    it { expect(user).to_not be_valid }
  end

  context 'with a non-unique username (case insensitive)' do
    before { FactoryGirl.create(:user, username: 'Username') }
    before { user.username = 'username' }

    it { expect(user).to_not be_valid }
  end

  context 'with a username that contains spaces' do
    before { user.username = 'user name' }

    it { expect(user).to_not be_valid }
  end

  context 'with a username that contains symbols' do
    before { user.username = 'user%name' }

    it { expect(user).to_not be_valid }
  end

  describe 'project_member?' do
    let(:project) { FactoryGirl.create(:project) }

    before { user.save }

    context 'the user is not a project member' do
      it { expect(user.project_member?(project)).to be_falsey }
    end

    context 'the user is a project member' do
      before { FactoryGirl.create(:membership, user: user, project: project) }

      it { expect(user.project_member?(project)).to be_truthy }
    end
  end
end
