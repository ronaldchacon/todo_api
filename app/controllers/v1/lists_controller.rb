module V1
  class ListsController < ApplicationController
    before_action :authenticate_user

    def index
      @lists = orchestrate_query(List.includes(:tasks).all)
      render json: @lists, include: ["tasks"], status: 200
    end

    def show
      @list = List.includes(:tasks).find_by!(id: params[:id])
      render json: @list, status: 200
    end

    def create
      @list = List.new(list_attributes)
      if @list.save
        render json: @list, status: :created, location: v1_list_url(@list)
      else
        respond_with_errors(@list)
      end
    end

    def update
      @list = List.find_by!(id: params[:id])
      if @list.update(list_attributes)
        render json: @list, status: :ok, location: v1_list_url(@list)
      else
        respond_with_errors(@list)
      end
    end

    def destroy
      List.find_by!(id: params[:id]).destroy
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
