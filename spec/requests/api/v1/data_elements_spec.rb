require 'rails_helper'

describe 'DataElements requests', type: :request do
  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project) }
  let(:data_element) { FactoryGirl.create(:data_element, project: project) }

  def create_valid_data_element_attributes(owner_project)
    {
        'label' => Faker::Lorem.word,
        'description' => Faker::Lorem.sentence,
        'project-id' => owner_project.id.to_s
    }
  end

  context 'without a valid OAuth token' do
    let(:headers) { {
        CONTENT_TYPE: 'application/vnd.api+json'
    } }

    describe 'GET api/v1/data-elements' do
      before { get '/api/v1/data-elements', {}, headers }

      it { expect(response.status).to eql(401) }
    end

    describe 'GET api/v1/data-elements/:data_element_id' do
      before { get "/api/v1/data-elements/#{data_element.id}", {}, headers }

      it { expect(response.status).to eql(200) }
    end

    describe 'POST api/v1/data-elements' do
      context 'with valid data' do
        let(:json) { {
            data: {
                type: 'data-elements',
                attributes: create_valid_data_element_attributes(project)
            }
        }.to_json }

        before { post '/api/v1/data-elements', json, headers }

        it { expect(response.status).to eql(401) }
      end
    end

    describe 'PUT api/v1/data-elements/:data_element_id' do
      context 'with valid data' do
        let(:json) { {
            data: {
                type: 'data-elements',
                id: data_element.id.to_s,
                attributes: create_valid_data_element_attributes(project)
            }
        }.to_json }

        before { put "/api/v1/data-elements/#{data_element.id}", json, headers }

        it { expect(response.status).to eql(401) }
      end
    end

    describe 'DELETE api/v1/data-elements/:data_element_id' do
      before { delete "/api/v1/data-elements/#{data_element.id}", {}, headers }

      it { expect(response.status).to eql(401) }
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

      it { expect(response.status).to eql(401) }
    end

    describe 'POST api/v1/data-elements' do
      before { FactoryGirl.create(:membership, project: project, user: user) }

      context 'with valid data for a new data element for a project the user is not a member of' do
        let(:other_project) { FactoryGirl.create(:project) }
        let(:json) { {
            data: {
                type: 'data-elements',
                attributes: create_valid_data_element_attributes(other_project)
            }
        }.to_json }

        before { post '/api/v1/data-elements', json, headers }

        it { expect(response.status).to eql(401) }
      end

      context 'with valid data for a new data element for a project the user is a member of' do
        let(:json) { {
            data: {
                type: 'data-elements',
                attributes: create_valid_data_element_attributes(project)
            }
        }.to_json }

        before { post '/api/v1/data-elements', json, headers }

        it { expect(response.status).to eql(201) }
      end
    end

    describe 'request methods that concern a single data_element' do
      context 'the current user is not a member of the project the data element belongs to' do
        describe 'GET api/v1/data-elements/:data_element_id' do
          before { get "/api/v1/data-elements/#{data_element.id}", {}, headers }

          it { expect(response.status).to eql(200) }
        end

        describe 'PUT api/v1/data-elements/:data_element_id' do
          context 'with valid data' do
            let(:json) { {
                data: {
                    type: 'data-elements',
                    id: data_element.id.to_s,
                    attributes: create_valid_data_element_attributes(project)
                }
            }.to_json }

            before { put "/api/v1/data-elements/#{data_element.id}", json, headers }

            it { expect(response.status).to eql(401) }
          end
        end

        describe 'DELETE api/v1/data-elements/:data_element_id' do
          before { delete "/api/v1/data-elements/#{data_element.id}", {}, headers }

          it { expect(response.status).to eql(401) }
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
            let(:json) { {
                data: {
                    type: 'data-elements',
                    id: data_element.id.to_s,
                    attributes: create_valid_data_element_attributes(project)
                }
            }.to_json }

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
