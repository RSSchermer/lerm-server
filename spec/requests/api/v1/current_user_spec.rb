require 'rails_helper'

describe 'CurrentUser requests', type: :request do
  let(:user) { FactoryGirl.create(:user) }

  context 'without a valid OAuth token' do
    let(:headers) { {
        CONTENT_TYPE: 'application/vnd.api+json'
    } }

    describe 'GET api/v1/current-user' do
      before { get '/api/v1/current-user', {}, headers }

      it { expect(response.status).to eql(401) }
    end

    describe 'POST api/v1/current-user' do
      before { post '/api/v1/current-user', {}, headers }

      it { expect(response.status).to eql(401) }
    end
  end

  context 'with a valid OAuth token' do
    let(:token) { FactoryGirl.create(:access_token, resource_owner_id: user.id) }
    let(:headers) { {
        CONTENT_TYPE: 'application/vnd.api+json',
        AUTHORIZATION: "Bearer #{token.token}"
    } }

    describe 'GET api/v1/current-user' do
      before { get '/api/v1/current-user', {}, headers }


      it { expect(response.status).to eql(200) }
    end

    describe 'POST api/v1/current-user' do
      context 'with valid data' do
        let(:json) { {
            data: {
                type: 'users',
                attributes: FactoryGirl.attributes_for(:user)
            }
        }.to_json }

        before { post '/api/v1/current-user', json, headers }

        it {
          expect(response.status).to eql(400) }
      end
    end
  end
end
