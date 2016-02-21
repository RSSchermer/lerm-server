require 'rails_helper'

describe 'Phrases requests', type: :request do
  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project) }
  let(:rule) { FactoryGirl.create(:rule, project: project)}
  let(:phrase) { FactoryGirl.create(:phrase, rule: rule) }

  def create_valid_phrase_attributes(owner_rule)
    {
        'text' => Faker::Lorem.word,
        'rule-id' => owner_rule.id.to_s
    }
  end

  context 'without a valid OAuth token' do
    let(:headers) { {
        CONTENT_TYPE: 'application/vnd.api+json'
    } }

    describe 'GET api/v1/phrases' do
      before { get '/api/v1/phrases', {}, headers }

      it { expect(response.status).to eql(401) }
    end

    describe 'GET api/v1/phrases/:phrase_id' do
      before { get "/api/v1/phrases/#{phrase.id}", {}, headers }

      it { expect(response.status).to eql(200) }
    end

    describe 'POST api/v1/phrases' do
      context 'with valid data' do
        let(:json) { {
            data: {
                type: 'phrases',
                attributes: create_valid_phrase_attributes(rule)
            }
        }.to_json }

        before { post '/api/v1/phrases', json, headers }

        it { expect(response.status).to eql(401) }
      end
    end

    describe 'PUT api/v1/phrases/:phrase_id' do
      context 'with valid data' do
        let(:json) { {
            data: {
                type: 'phrases',
                id: phrase.id.to_s,
                attributes: create_valid_phrase_attributes(rule)
            }
        }.to_json }

        before { put "/api/v1/phrases/#{phrase.id}", json, headers }

        it { expect(response.status).to eql(401) }
      end
    end

    describe 'DELETE api/v1/phrases/:phrase_id' do
      before { delete "/api/v1/phrases/#{phrase.id}", {}, headers }

      it { expect(response.status).to eql(401) }
    end
  end

  context 'with a valid OAuth token' do
    let(:token) { FactoryGirl.create(:access_token, resource_owner_id: user.id) }
    let(:headers) { {
        CONTENT_TYPE: 'application/vnd.api+json',
        AUTHORIZATION: "Bearer #{token.token}"
    } }

    describe 'GET api/v1/phrases' do
      before { get '/api/v1/phrases', {}, headers }

      it { expect(response.status).to eql(401) }
    end

    describe 'POST api/v1/phrases' do
      before { FactoryGirl.create(:membership, project: project, user: user) }

      context 'with valid data for a new phrase for a project the user is not a member of' do
        let(:other_rule) { FactoryGirl.create(:rule) }
        let(:json) { {
            data: {
                type: 'phrases',
                attributes: create_valid_phrase_attributes(other_rule)
            }
        }.to_json }

        before { post '/api/v1/phrases', json, headers }

        it { expect(response.status).to eql(401) }
      end

      context 'with valid data for a new phrase for a project the user is a member of' do
        let(:json) { {
            data: {
                type: 'phrases',
                attributes: create_valid_phrase_attributes(rule)
            }
        }.to_json }

        before { post '/api/v1/phrases', json, headers }

        it { expect(response.status).to eql(201) }
      end
    end

    describe 'request methods that concern a single phrase' do
      context 'the current user is not a member of the project the phrase belongs to' do
        describe 'GET api/v1/phrases/:phrase_id' do
          before { get "/api/v1/phrases/#{phrase.id}", {}, headers }

          it { expect(response.status).to eql(200) }
        end

        describe 'PUT api/v1/phrases/:phrase_id' do
          context 'with valid data' do
            let(:json) { {
                data: {
                    type: 'phrases',
                    id: phrase.id.to_s,
                    attributes: create_valid_phrase_attributes(rule)
                }
            }.to_json }

            before { put "/api/v1/phrases/#{phrase.id}", json, headers }

            it { expect(response.status).to eql(401) }
          end
        end

        describe 'DELETE api/v1/phrases/:phrase_id' do
          before { delete "/api/v1/phrases/#{phrase.id}", {}, headers }

          it { expect(response.status).to eql(401) }
        end
      end

      context 'the current user is a member of the project the phrase belongs to' do
        before { FactoryGirl.create(:membership, project: project, user: user) }

        describe 'GET api/v1/phrases/:phrase_id' do
          before { get "/api/v1/phrases/#{phrase.id}", {}, headers }

          it { expect(response.status).to eql(200) }
        end

        describe 'PUT api/v1/phrases/:phrase_id' do
          context 'with valid data' do
            let(:json) { {
                data: {
                    type: 'phrases',
                    id: phrase.id.to_s,
                    attributes: create_valid_phrase_attributes(rule)
                }
            }.to_json }

            before { put "/api/v1/phrases/#{phrase.id}", json, headers }

            it { expect(response.status).to eql(200) }
          end
        end

        describe 'DELETE api/v1/phrases/:phrase_id' do
          before { delete "/api/v1/phrases/#{phrase.id}", {}, headers }

          it { expect(response.status).to eql(204) }
        end
      end
    end
  end
end
