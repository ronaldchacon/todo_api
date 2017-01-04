module V1
  class ListsController < ApplicationController
    before_action :authenticate_user

    def index
      @lists = orchestrate_query(current_user.lists.includes(:tasks).all)
      render json: @lists, include: ["tasks"], status: 200
    end

    def show
      @list = current_user.lists.includes(:tasks).find_by!(id: params[:id])
      render json: @list, status: 200
    end

    def create
      attributes = list_attributes.merge(user_id: current_user.id)
      @list = List.new(attributes)
      if @list.save
        render json: @list, status: :created, location: v1_list_url(@list)
      else
        respond_with_errors(@list)
      end
    end

    def update
      @list = current_user.lists.find_by!(id: params[:id])
      if @list.update(list_attributes)
        render json: @list, status: :ok, location: v1_list_url(@list)
      else
        respond_with_errors(@list)
      end
    end

    def destroy
      current_user.lists.find_by!(id: params[:id]).destroy
      render status: :no_content
    end

    private

    def list_params
      params.require(:data).permit(:type, attributes: [:title])
    end

    def list_attributes
      list_params[:attributes] || {}
    end
  end
end
