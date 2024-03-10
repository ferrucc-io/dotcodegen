# frozen_string_literal: true

class LabelsController < ApplicationController
  before_action :verify_user_has_permission_for_app

  def index
    @labels = Label.where(app:).limit(100)
  end

  def show
    @label = Label.find_by(id: params[:id], app:)
    render json: { error: 'Label not found' }, status: :not_found unless @label
  end

  def create
    @label = Labels::Create.run!(color: params[:color], name: params[:name], app_id: app.id)
    render :show
  end

  def update
    @label = Labels::Update.run!(app_id: app.id, id: params[:id], name: params[:name], color: params[:color])
    render :show
  end

  def destroy
    Labels::Destroy.run!(id: params[:id], app_id: app.id)
    render json: { status: 200, message: 'Label deleted successfully' }
  end
end
