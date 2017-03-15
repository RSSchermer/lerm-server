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

  describe 'clone_for' do
    context 'the project is persisted' do
      before { project.save! }

      context 'various related models exist for the project' do
        before do
          data_elements = FactoryGirl.create_list(:data_element, 2, project: project)
          rules = FactoryGirl.create_list(:rule, 2, project: project)
          FactoryGirl.create(:statement, rule: rules[0])
          phrase = FactoryGirl.create(:phrase, rule: rules[0])
          phrase.data_elements << data_elements[0]
          FactoryGirl.create(:rule_conflict, project: project, rule_one: rules[0], rule_two: rules[1])
          FactoryGirl.create(:rule_relationship, project: project, rule_one: rules[0], rule_two: rules[1])
        end

        context 'a user exists' do
          let(:user) { FactoryGirl.create(:user, username: 'someuser') }

          describe 'clone' do
            let(:clone) { project.clone_for(user, 'My clone') }

            it { expect(clone.name).to eq('My clone') }
            it { expect(clone.data_elements.length).to eq(2) }
            it { expect(clone.rules.length).to eq(2) }
            it { expect(clone.rule_conflicts.length).to eq(1) }
            it { expect(clone.rule_relationships.length).to eq(1) }

            describe 'first rule' do
              let(:rule) { clone.rules.first }

              it { expect(rule.statements.length).to eq(1) }
              it { expect(rule.phrases.length).to eq(1) }

              describe 'phrase' do
                let(:phrase) { rule.phrases.first }

                it { expect(phrase.data_elements[0].id).to eq(clone.data_elements[0].id) }
              end
            end

            describe 'rule conflict' do
              let(:rule_conflict) { clone.rule_conflicts.first }

              it { expect(rule_conflict.rule_one_id).to eq(clone.rules[0].id) }
              it { expect(rule_conflict.rule_two_id).to eq(clone.rules[1].id) }
            end

            describe 'rule relationship' do
              let(:rule_relationship) { clone.rule_relationships.first }

              it { expect(rule_relationship.rule_one_id).to eq(clone.rules[0].id) }
              it { expect(rule_relationship.rule_two_id).to eq(clone.rules[1].id) }
            end
          end
        end
      end
    end
  end
end
