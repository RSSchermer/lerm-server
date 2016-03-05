require 'rails_helper'

describe 'DataElements requests', type: :request do
  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project) }

  def create_valid_data_element_json(owner_project, id = nil)
    valid_data = {
        data: {
            type: 'data-elements',
            attributes: {
                label: Faker::Lorem.word,
                description: Faker::Lorem.sentence
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

    describe 'GET api/v1/data-elements' do
      before { get '/api/v1/data-elements', {}, headers }

      it { expect(response.status).to eql(403) }
    end

    describe 'POST api/v1/data-elements' do
      context 'with valid data' do
        let(:json) { create_valid_data_element_json(project) }

        before { post '/api/v1/data-elements', json, headers }

        it { expect(response.status).to eql(401) }
      end
    end

    describe 'requests that concern a specific instance' do
      let(:data_element) { FactoryGirl.create(:data_element, project: project) }

      describe 'GET api/v1/data-elements/:data_element_id' do
        before { get "/api/v1/data-elements/#{data_element.id}", {}, headers }

        it { expect(response.status).to eql(200) }
      end

      describe 'PUT api/v1/data-elements/:data_element_id' do
        context 'with valid data' do
          let(:json) { create_valid_data_element_json(project, data_element.id) }

          before { put "/api/v1/data-elements/#{data_element.id}", json, headers }

          it { expect(response.status).to eql(401) }
        end
      end

      describe 'DELETE api/v1/data-elements/:data_element_id' do
        before { delete "/api/v1/data-elements/#{data_element.id}", {}, headers }

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

    describe 'GET api/v1/data-elements' do
      before { get '/api/v1/data-elements', {}, headers }

      it { expect(response.status).to eql(403) }
    end

    describe 'POST api/v1/data-elements' do
      before { FactoryGirl.create(:membership, project: project, user: user) }

      context 'with valid data for a new data element for a project the user is not a member of' do
        let(:other_project) { FactoryGirl.create(:project) }
        let(:json) { create_valid_data_element_json(other_project) }

        before { post '/api/v1/data-elements', json, headers }

        it { expect(response.status).to eql(403) }
      end

      context 'with valid data for a new data element for a project the user is a member of' do
        let(:json) { create_valid_data_element_json(project) }

        before { post '/api/v1/data-elements', json, headers }

        it { expect(response.status).to eql(201) }
      end
    end

    describe 'requests that concern a specific instance' do
      let(:data_element) { FactoryGirl.create(:data_element, project: project) }

      context 'the current user is not a member of the project the data element belongs to' do
        describe 'GET api/v1/data-elements/:data_element_id' do
          before { get "/api/v1/data-elements/#{data_element.id}", {}, headers }

          it { expect(response.status).to eql(200) }
        end

        describe 'PUT api/v1/data-elements/:data_element_id' do
          context 'with valid data' do
            let(:json) { create_valid_data_element_json(project, data_element.id) }

            before { put "/api/v1/data-elements/#{data_element.id}", json, headers }

            it { expect(response.status).to eql(403) }
          end
        end

        describe 'DELETE api/v1/data-elements/:data_element_id' do
          before { delete "/api/v1/data-elements/#{data_element.id}", {}, headers }

          it { expect(response.status).to eql(403) }
        end
      end

      context 'the current user is a member of the project the data element belongs to' do
        before { FactoryGirl.create(:membership, project: project, user: user) }

        describe 'GET api/v1/data-elements/:data_element_id' do
          before { get "/api/v1/data-elements/#{data_element.id}", {}, headers }

          it { expect(response.status).to eql(200) }
        end

        describe 'PUT api/v1/data-elements/:data_element_id' do
          context 'with valid data' do
            let(:json) { create_valid_data_element_json(project, data_element.id) }

            before { put "/api/v1/data-elements/#{data_element.id}", json, headers }

            it { expect(response.status).to eql(200) }
          end
        end

        describe 'DELETE api/v1/data-elements/:data_element_id' do
          before { delete "/api/v1/data-elements/#{data_element.id}", {}, headers }

          it { expect(response.status).to eql(204) }
        end
      end
    end
  end
end
