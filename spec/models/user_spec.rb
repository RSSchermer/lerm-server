require 'rails_helper'

describe User do
  subject(:user) { FactoryGirl.build(:user) }

  it 'should have a valid factory' do
    expect(user).to be_valid
  end

  describe 'project_member?' do
    let(:project) { FactoryGirl.create(:project) }

    context 'the user is not a project member' do
      it { expect(user.project_member?(project)).to be_falsey }
    end

    context 'the user is a project member' do
      before { FactoryGirl.create(:membership, user: user, project: project) }

      it { expect(user.project_member?(project)).to be_truthy }
    end
  end
end
