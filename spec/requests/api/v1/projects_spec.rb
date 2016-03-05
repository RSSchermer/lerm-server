require 'rails_helper'

describe 'Projects requests', type: :request do
  let(:user) { FactoryGirl.create(:user) }

  def create_valid_project_json(id = nil)
    valid_data = {
        data: {
            type: 'projects',
            attributes: FactoryGirl.attributes_for(:project)
        }
    }

    valid_data[:data][:id] = id.to_s unless id.nil?

    valid_data.to_json
  end

  context 'without a valid OAuth token' do
    let(:headers) { {
        CONTENT_TYPE: 'application/vnd.api+json'
    } }

    describe 'GET api/v1/projects' do
      before { get '/api/v1/projects', {}, headers }

      it { expect(response.status).to eql(200) }
    end

    describe 'POST api/v1/projects' do
      context 'with valid data' do
        let(:json) { create_valid_project_json }

        before { post '/api/v1/projects', json, headers }

        it { expect(response.status).to eql(401) }
      end
    end

    describe 'requests that concern a specific instance' do
      let(:project) { FactoryGirl.create(:project) }

      describe 'GET api/v1/projects/:project_id' do
        before { get "/api/v1/projects/#{project.id}", {}, headers }

        it { expect(response.status).to eql(200) }
      end

      describe 'PUT api/v1/projects/:project_id' do
        context 'with valid data' do
          let(:json) { create_valid_project_json(project.id) }

          before { put "/api/v1/projects/#{project.id}", json, headers }

          it { expect(response.status).to eql(401) }
        end
      end

      describe 'DELETE api/v1/projects/:project_id' do
        before { delete "/api/v1/projects/#{project.id}", {}, headers }

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

    describe 'GET api/v1/projects' do
      before { get '/api/v1/projects', {}, headers }

      it { expect(response.status).to eql(200) }
    end

    describe 'POST api/v1/projects' do
      context 'with valid data' do
        let(:json) { create_valid_project_json }

        before { post '/api/v1/projects', json, headers }

        it { expect(response.status).to eql(201) }
      end
    end

    describe 'requests that concern a specific instance' do
      let(:project) { FactoryGirl.create(:project) }

      context 'the current user is not a project member' do
        describe 'GET api/v1/projects/:project_id' do
          before { get "/api/v1/projects/#{project.id}", {}, headers }

          it { expect(response.status).to eql(200) }
        end

        describe 'PUT api/v1/projects/:project_id' do
          context 'with valid data' do
            let(:json) { create_valid_project_json(project.id) }

            before { put "/api/v1/projects/#{project.id}", json, headers }

            it { expect(response.status).to eql(403) }
          end
        end

        describe 'DELETE api/v1/projects/:project_id' do
          before { delete "/api/v1/projects/#{project.id}", {}, headers }

          it { expect(response.status).to eql(405) }
        end
      end

      context 'the current user is a project member' do
        before { FactoryGirl.create(:membership, project: project, user: user) }

        describe 'GET api/v1/projects/:project_id' do
          before { get "/api/v1/projects/#{project.id}", {}, headers }

          it { expect(response.status).to eql(200) }
        end

        describe 'PUT api/v1/projects/:project_id' do
          context 'with valid data' do
            let(:json) { create_valid_project_json(project.id) }

            before { put "/api/v1/projects/#{project.id}", json, headers }

            it { expect(response.status).to eql(200) }
          end
        end

        describe 'DELETE api/v1/projects/:project_id' do
          before { delete "/api/v1/projects/#{project.id}", {}, headers }

          it { expect(response.status).to eql(405) }
        end
      end
    end
  end
end
