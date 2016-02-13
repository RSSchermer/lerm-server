require 'rails_helper'

describe Project do
  let(:rule) { FactoryGirl.create(:rule) }
  subject(:phrase) { FactoryGirl.build(:phrase, rule: rule) }

  it 'should have a valid factory' do
    expect(phrase).to be_valid
  end

  context 'without text' do
    before { phrase.text = nil }

    it { expect(phrase).to_not be_valid }
  end

  context 'with a non-unique name within a rule' do
    let(:other_phrase) { FactoryGirl.create(:phrase, rule: rule) }

    before { phrase.text = other_phrase.text }

    it { expect(phrase).to_not be_valid }
  end

  context 'with a non-unique global name, but unique within a rule' do
    let(:other_rule) { FactoryGirl.create(:rule) }
    let(:other_phrase) { FactoryGirl.create(:phrase, rule: other_rule) }

    before { phrase.text = other_phrase.text }

    it { expect(phrase).to be_valid }
  end

  context 'without a rule' do
    before { phrase.rule = nil }

    it { expect(phrase).to_not be_valid }
  end
end
