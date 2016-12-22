module V1
  class ListsController < ApplicationController
    def index
      @lists = orchestrate_query(List.includes(:tasks).all)
      render json: @lists, include: ['tasks'], status: 200
    end

    def show
      @list = List.includes(:tasks).find_by!(id: params[:id])
      render json: @list, status: 200
    end
  end
end
