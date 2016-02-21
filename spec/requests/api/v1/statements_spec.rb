require 'rails_helper'

describe 'Statements requests', type: :request do
  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project) }
  let(:rule) { FactoryGirl.create(:rule, project: project)}
  let(:statement) { FactoryGirl.create(:statement, rule: rule) }

  def create_valid_statement_attributes(owner_rule)
    {
        'condition' => Faker::Lorem.sentence,
        'consequence' => Faker::Lorem.sentence,
        'rule-id' => owner_rule.id.to_s
    }
  end

  context 'without a valid OAuth token' do
    let(:headers) { {
        CONTENT_TYPE: 'application/vnd.api+json'
    } }

    describe 'GET api/v1/statements' do
      before { get '/api/v1/statements', {}, headers }

      it { expect(response.status).to eql(401) }
    end

    describe 'GET api/v1/statements/:statement_id' do
      before { get "/api/v1/statements/#{statement.id}", {}, headers }

      it { expect(response.status).to eql(200) }
    end

    describe 'POST api/v1/statements' do
      context 'with valid data' do
        let(:json) { {
            data: {
                type: 'statements',
                attributes: create_valid_statement_attributes(rule)
            }
        }.to_json }

        before { post '/api/v1/statements', json, headers }

        it { expect(response.status).to eql(401) }
      end
    end

    describe 'PUT api/v1/statements/:statement_id' do
      context 'with valid data' do
        let(:json) { {
            data: {
                type: 'statements',
                id: statement.id.to_s,
                attributes: create_valid_statement_attributes(rule)
            }
        }.to_json }

        before { put "/api/v1/statements/#{statement.id}", json, headers }

        it { expect(response.status).to eql(401) }
      end
    end

    describe 'DELETE api/v1/statements/:statement_id' do
      before { delete "/api/v1/statements/#{statement.id}", {}, headers }

      it { expect(response.status).to eql(401) }
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

      it { expect(response.status).to eql(401) }
    end

    describe 'POST api/v1/statements' do
      before { FactoryGirl.create(:membership, project: project, user: user) }

      context 'with valid data for a new statement for a project the user is not a member of' do
        let(:other_rule) { FactoryGirl.create(:rule) }
        let(:json) { {
            data: {
                type: 'statements',
                attributes: create_valid_statement_attributes(other_rule)
            }
        }.to_json }

        before { post '/api/v1/statements', json, headers }

        it { expect(response.status).to eql(401) }
      end

      context 'with valid data for a new statement for a project the user is a member of' do
        let(:json) { {
            data: {
                type: 'statements',
                attributes: create_valid_statement_attributes(rule)
            }
        }.to_json }

        before { post '/api/v1/statements', json, headers }

        it { expect(response.status).to eql(201) }
      end
    end

    describe 'request methods that concern a single statement' do
      context 'the current user is not a member of the project the statement belongs to' do
        describe 'GET api/v1/statements/:statement_id' do
          before { get "/api/v1/statements/#{statement.id}", {}, headers }

          it { expect(response.status).to eql(200) }
        end

        describe 'PUT api/v1/statements/:statement_id' do
          context 'with valid data' do
            let(:json) { {
                data: {
                    type: 'statements',
                    id: statement.id.to_s,
                    attributes: create_valid_statement_attributes(rule)
                }
            }.to_json }

            before { put "/api/v1/statements/#{statement.id}", json, headers }

            it { expect(response.status).to eql(401) }
          end
        end

        describe 'DELETE api/v1/statements/:statement_id' do
          before { delete "/api/v1/statements/#{statement.id}", {}, headers }

          it { expect(response.status).to eql(401) }
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
            let(:json) { {
                data: {
                    type: 'statements',
                    id: statement.id.to_s,
                    attributes: create_valid_statement_attributes(rule)
                }
            }.to_json }

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
