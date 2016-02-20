require 'rails_helper'

describe 'Users requests', type: :request do
  let(:current_user) { FactoryGirl.create(:user) }
  let(:user) { FactoryGirl.create(:user) }

  context 'without a valid OAuth token' do
    let(:headers) { {
        CONTENT_TYPE: 'application/vnd.api+json'
    } }

    describe 'GET api/v1/users' do
      before { get '/api/v1/users', {}, headers }

      it { expect(response.status).to eql(200) }
    end

    describe 'GET api/v1/users/:user_id' do
      before { get "/api/v1/users/#{user.id}", {}, headers }

      it { expect(response.status).to eql(200) }
    end
  end

  context 'with a valid OAuth token' do
    let(:token) { FactoryGirl.create(:access_token, resource_owner_id: current_user.id) }
    let(:headers) { {
        CONTENT_TYPE: 'application/vnd.api+json',
        AUTHORIZATION: "Bearer #{token.token}"
    } }

    describe 'GET api/v1/users' do
      before { get '/api/v1/users', {}, headers }

      it { expect(response.status).to eql(200) }
    end

    describe 'GET api/v1/users/:user_id' do
      before { get "/api/v1/users/#{user.id}", {}, headers }

      it { expect(response.status).to eql(200) }
    end
  end
end
