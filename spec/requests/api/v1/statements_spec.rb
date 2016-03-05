require 'rails_helper'

describe 'Statements requests', type: :request do
  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project) }
  let(:rule) { FactoryGirl.create(:rule, project: project)}

  def create_valid_statement_json(owner_rule, id = nil)
    valid_data = {
        data: {
            type: 'statements',
            attributes: {
                condition: Faker::Lorem.sentence,
                consequence: Faker::Lorem.sentence
            },
            relationships: {
                rule: { data: { type: 'rules', id: owner_rule.id.to_s } }
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

    describe 'GET api/v1/statements' do
      before { get '/api/v1/statements', {}, headers }

      it { expect(response.status).to eql(403) }
    end

    describe 'POST api/v1/statements' do
      context 'with valid data' do
        let(:json) { create_valid_statement_json(rule) }

        before { post '/api/v1/statements', json, headers }

        it { expect(response.status).to eql(401) }
      end
    end

    describe 'requests that concern a specific instance' do
      let(:statement) { FactoryGirl.create(:statement, rule: rule) }

      describe 'GET api/v1/statements/:statement_id' do
        before { get "/api/v1/statements/#{statement.id}", {}, headers }

        it { expect(response.status).to eql(200) }
      end

      describe 'PUT api/v1/statements/:statement_id' do
        context 'with valid data' do
          let(:json) { create_valid_statement_json(rule, statement.id) }

          before { put "/api/v1/statements/#{statement.id}", json, headers }

          it { expect(response.status).to eql(401) }
        end
      end

      describe 'DELETE api/v1/statements/:statement_id' do
        before { delete "/api/v1/statements/#{statement.id}", {}, headers }

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

    describe 'GET api/v1/statements' do
      before { get '/api/v1/statements', {}, headers }

      it { expect(response.status).to eql(403) }
    end

    describe 'POST api/v1/statements' do
      before { FactoryGirl.create(:membership, project: project, user: user) }

      context 'with valid data for a new statement for a project the user is not a member of' do
        let(:other_rule) { FactoryGirl.create(:rule) }
        let(:json) { create_valid_statement_json(other_rule) }

        before { post '/api/v1/statements', json, headers }

        it { expect(response.status).to eql(403) }
      end

      context 'with valid data for a new statement for a project the user is a member of' do
        let(:json) { create_valid_statement_json(rule) }

        before { post '/api/v1/statements', json, headers }

        it { expect(response.status).to eql(201) }
      end
    end

    describe 'requests that concern a specific instance' do
      let(:statement) { FactoryGirl.create(:statement, rule: rule) }

      context 'the current user is not a member of the project the statement belongs to' do
        describe 'GET api/v1/statements/:statement_id' do
          before { get "/api/v1/statements/#{statement.id}", {}, headers }

          it { expect(response.status).to eql(200) }
        end

        describe 'PUT api/v1/statements/:statement_id' do
          context 'with valid data' do
            let(:json) { create_valid_statement_json(rule, statement.id) }

            before { put "/api/v1/statements/#{statement.id}", json, headers }

            it { expect(response.status).to eql(403) }
          end
        end

        describe 'DELETE api/v1/statements/:statement_id' do
          before { delete "/api/v1/statements/#{statement.id}", {}, headers }

          it { expect(response.status).to eql(403) }
        end
      end

      context 'the current user is a member of the project the statement belongs to' do
        before { FactoryGirl.create(:membership, project: project, user: user) }

        describe 'GET api/v1/statements/:statement_id' do
          before { get "/api/v1/statements/#{statement.id}", {}, headers }

          it { expect(response.status).to eql(200) }
        end

        describe 'PUT api/v1/statements/:statement_id' do
          context 'with valid data' do
            let(:json) { create_valid_statement_json(rule, statement.id) }

            before { put "/api/v1/statements/#{statement.id}", json, headers }

            it { expect(response.status).to eql(200) }
          end
        end

        describe 'DELETE api/v1/statements/:statement_id' do
          before { delete "/api/v1/statements/#{statement.id}", {}, headers }

          it { expect(response.status).to eql(204) }
        end
      end
    end
  end
end
