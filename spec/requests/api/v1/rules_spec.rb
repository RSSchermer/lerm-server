require 'rails_helper'

describe 'Rules requests', type: :request do
  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project) }

  def create_valid_rule_json(owner_project, id = nil)
    valid_data = {
        data: {
            type: 'rules',
            attributes: {
                label: Faker::Lorem.word,
                'original-text': Faker::Lorem.sentence
            },
            relationships: {
                project: { data: { type: 'projects', id: owner_project.id.to_s } }
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

    describe 'GET api/v1/rules' do
      before { get '/api/v1/rules', {}, headers }

      it { expect(response.status).to eql(403) }
    end

    describe 'POST api/v1/rules' do
      context 'with valid data' do
        let(:json) { create_valid_rule_json(project) }

        before { post '/api/v1/rules', json, headers }

        it { expect(response.status).to eql(401) }
      end
    end

    describe 'requests that concern a specific instance' do
      let(:rule) { FactoryGirl.create(:rule, project: project) }

      describe 'GET api/v1/rules/:rule_id' do
        before { get "/api/v1/rules/#{rule.id}", {}, headers }

        it { expect(response.status).to eql(200) }
      end

      describe 'PUT api/v1/rules/:rule_id' do
        context 'with valid data' do
          let(:json) { create_valid_rule_json(project, rule.id) }

          before { put "/api/v1/rules/#{rule.id}", json, headers }

          it { expect(response.status).to eql(401) }
        end
      end

      describe 'DELETE api/v1/rules/:rule_id' do
        before { delete "/api/v1/rules/#{rule.id}", {}, headers }

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

    describe 'GET api/v1/rules' do
      before { get '/api/v1/rules', {}, headers }

      it { expect(response.status).to eql(403) }
    end

    describe 'POST api/v1/rules' do
      before { FactoryGirl.create(:membership, project: project, user: user) }

      context 'with valid data for a new rule for a project the user is not a member of' do
        let(:other_project) { FactoryGirl.create(:project) }
        let(:json) { create_valid_rule_json(other_project) }

        before { post '/api/v1/rules', json, headers }

        it { expect(response.status).to eql(403) }
      end

      context 'with valid data for a new rule for a project the user is a member of' do
        let(:json) { create_valid_rule_json(project) }

        before { post '/api/v1/rules', json, headers }

        it { expect(response.status).to eql(201) }
      end
    end

    describe 'requests that concern a specific instance' do
      let(:rule) { FactoryGirl.create(:rule, project: project) }

      context 'the current user is not a member of the project the rule belongs to' do
        describe 'GET api/v1/rules/:rule_id' do
          before { get "/api/v1/rules/#{rule.id}", {}, headers }

          it { expect(response.status).to eql(200) }
        end

        describe 'PUT api/v1/rules/:rule_id' do
          context 'with valid data' do
            let(:json) { create_valid_rule_json(project, rule.id) }

            before { put "/api/v1/rules/#{rule.id}", json, headers }

            it { expect(response.status).to eql(403) }
          end
        end

        describe 'DELETE api/v1/rules/:rule_id' do
          before { delete "/api/v1/rules/#{rule.id}", {}, headers }

          it { expect(response.status).to eql(403) }
        end
      end

      context 'the current user is a member of the project the rule belongs to' do
        before { FactoryGirl.create(:membership, project: project, user: user) }

        describe 'GET api/v1/rules/:rule_id' do
          before { get "/api/v1/rules/#{rule.id}", {}, headers }

          it { expect(response.status).to eql(200) }
        end

        describe 'PUT api/v1/rules/:rule_id' do
          context 'with valid data' do
            let(:json) { create_valid_rule_json(project, rule.id) }

            before { put "/api/v1/rules/#{rule.id}", json, headers }

            it { expect(response.status).to eql(200) }
          end
        end

        describe 'DELETE api/v1/rules/:rule_id' do
          before { delete "/api/v1/rules/#{rule.id}", {}, headers }

          it { expect(response.status).to eql(204) }
        end
      end
    end
  end
end
