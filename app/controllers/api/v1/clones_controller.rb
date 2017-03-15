class Api::V1::ClonesController < Api::V1::BaseResourceController
  before_action :doorkeeper_authorize!

  def create
    project = Project.find(params[:project_id])
    clone_params = params.require(:clone).permit(:name)

    if !clone_params[:name].blank? && Project.where(name: clone_params[:name]).empty?
      clone = project.clone_for(current_user, clone_params[:name])
      context = { current_user: current_user }
      render json: JSONAPI::ResourceSerializer.new(Api::V1::ProjectResource)
                       .serialize_to_hash(Api::V1::ProjectResource.new(clone, context)),
             status: 201
    else
      render json: {
          errors: [
              {
                  detail: {
                      name: 'Another project with this name already exists'
                  }
              }
          ]
      }, status: 422
    end
  end
end
