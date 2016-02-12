require 'rails_helper'

describe Project do
  subject(:project) { FactoryGirl.build(:project) }

  it 'should have a valid factory' do
    expect(project).to be_valid
  end

  context 'without name' do
    before { project.name = nil }

    it { expect(project).to_not be_valid }
  end

  context 'with a non-unique name' do
    let(:other_project) { FactoryGirl.create(:project) }

    before { project.name = other_project.name }

    it { expect(project).to_not be_valid }
  end
end
