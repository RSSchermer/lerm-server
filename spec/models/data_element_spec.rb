require 'rails_helper'

describe DataElement do
  let(:project) { FactoryGirl.create(:project) }
  subject(:data_element) { FactoryGirl.build(:data_element, project: project) }

  it 'should have a valid factory' do
    expect(data_element).to be_valid
  end

  context 'without name' do
    before { data_element.label = nil }

    it { expect(data_element).to_not be_valid }
  end

  context 'with a non-unique name within a project' do
    let(:other_data_element) { FactoryGirl.create(:data_element, project: project) }

    before { data_element.label = other_data_element.label }

    it { expect(data_element).to_not be_valid }
  end

  context 'with a non-unique global name, but unique within a project' do
    let(:other_project) { FactoryGirl.create(:project) }
    let(:other_data_element) { FactoryGirl.create(:data_element, project: other_project) }

    before { data_element.label = other_data_element.label }

    it { expect(data_element).to be_valid }
  end

  context 'without a description' do
    before { data_element.description = nil }

    it { expect(data_element).to_not be_valid }
  end

  context 'without a project' do
    before { data_element.project = nil }

    it { expect(data_element).to_not be_valid }
  end
end
