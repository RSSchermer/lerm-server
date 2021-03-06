require 'rails_helper'

describe 'RuleConflicts requests', type: :request do
  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project) }

  def create_valid_rule_conflict_json(owner_project, id = nil)
    valid_data = {
        data: {
            type: 'rule-conflicts',
            attributes: {
                description: Faker::Lorem.sentence
            },
            relationships: {
                project: { data: { type: 'projects', id: owner_project.id.to_s } },
                'rule-one': { data: {
                    type: 'rules',
                    id: FactoryGirl.create(:rule, project: owner_project).id.to_s
                } },
                'rule-two': { data: {
                    type: 'rules',
                    id: FactoryGirl.create(:rule, project: owner_project).id.to_s
                } }
            }
        }
    }

    valid_data[:data][:id] = id.to_s unless id.nil?

    valid_data.to_json
  end

  context 'without a valid OAuth token' do
    let(:headers) { {
        CONTENT_TYPE: 'application/vnd.api+json'
    } }

    describe 'GET api/v1/rule-conflicts' do
      before { get '/api/v1/rule-conflicts', {}, headers }

      it { expect(response.status).to eql(403) }
    end

    describe 'POST api/v1/rule-conflicts' do
      context 'with valid data' do
        let(:json) { create_valid_rule_conflict_json(project) }

        before { post '/api/v1/rule-conflicts', json, headers }

        it { expect(response.status).to eql(401) }
      end
    end

    describe 'requests that concern a specific instance' do
      let(:rule_conflict) { FactoryGirl.create(:rule_conflict, project: project) }

      describe 'GET api/v1/rule-conflicts/:rule_conflict_id' do
        before { get "/api/v1/rule-conflicts/#{rule_conflict.id}", {}, headers }

        it { expect(response.status).to eql(200) }
      end

      describe 'PUT api/v1/rule-conflicts/:rule_conflict_id' do
        context 'with valid data' do
          let(:json) { create_valid_rule_conflict_json(project, rule_conflict.id) }

          before { put "/api/v1/rule-conflicts/#{rule_conflict.id}", json, headers }

          it { expect(response.status).to eql(401) }
        end
      end

      describe 'DELETE api/v1/rule-conflicts/:rule_conflict_id' do
        before { delete "/api/v1/rule-conflicts/#{rule_conflict.id}", {}, headers }

        it { expect(response.status).to eql(401) }
      end
    end
  end

  context 'with a valid OAuth token' do
    let(:token) { FactoryGirl.create(:access_token, resource_owner_id: user.id) }
    let(:headers) { {
        CONTENT_TYPE: 'application/vnd.api+json',
        AUTHORIZATION: "Bearer #{token.token}"
    } }

    describe 'GET api/v1/rule-conflicts' do
      before { get '/api/v1/rule-conflicts', {}, headers }

      it { expect(response.status).to eql(403) }
    end

    describe 'POST api/v1/rule-conflicts' do
      before { FactoryGirl.create(:membership, project: project, user: user) }

      context 'with valid data for a new rule conflict for a project the user is not a member of' do
        let(:other_project) { FactoryGirl.create(:project) }
        let(:json) { create_valid_rule_conflict_json(other_project) }

        before { post '/api/v1/rule-conflicts', json, headers }

        it { expect(response.status).to eql(403) }
      end

      context 'with valid data for a new rule conflict for a project the user is a member of' do
        let(:json) { create_valid_rule_conflict_json(project) }

        before { post '/api/v1/rule-conflicts', json, headers }

        it { expect(response.status).to eql(201) }
      end
    end

    describe 'requests that concern a specific instance' do
      let(:rule_conflict) { FactoryGirl.create(:rule_conflict, project: project) }

      context 'the current user is not a member of the project the rule conflict belongs to' do
        describe 'GET api/v1/rule-conflicts/:rule_conflict_id' do
          before { get "/api/v1/rule-conflicts/#{rule_conflict.id}", {}, headers }

          it { expect(response.status).to eql(200) }
        end

        describe 'PUT api/v1/rule-conflicts/:rule_conflict_id' do
          context 'with valid data' do
            let(:json) { create_valid_rule_conflict_json(project, rule_conflict.id) }

            before { put "/api/v1/rule-conflicts/#{rule_conflict.id}", json, headers }

            it { expect(response.status).to eql(403) }
          end
        end

        describe 'DELETE api/v1/rule-conflicts/:rule_conflict_id' do
          before { delete "/api/v1/rule-conflicts/#{rule_conflict.id}", {}, headers }

          it { expect(response.status).to eql(403) }
        end
      end

      context 'the current user is a member of the project the rule conflict belongs to' do
        before { FactoryGirl.create(:membership, project: project, user: user) }

        describe 'GET api/v1/rule-conflicts/:rule_conflict_id' do
          before { get "/api/v1/rule-conflicts/#{rule_conflict.id}", {}, headers }

          it { expect(response.status).to eql(200) }
        end

        describe 'PUT api/v1/rule-conflicts/:rule_conflict_id' do
          context 'with valid data' do
            let(:json) { create_valid_rule_conflict_json(project, rule_conflict.id) }

            before { put "/api/v1/rule-conflicts/#{rule_conflict.id}", json, headers }

            it { expect(response.status).to eql(200) }
          end
        end

        describe 'DELETE api/v1/rule-conflicts/:rule_conflict_id' do
          before { delete "/api/v1/rule-conflicts/#{rule_conflict.id}", {}, headers }

          it { expect(response.status).to eql(204) }
        end
      end
    end
  end
end
