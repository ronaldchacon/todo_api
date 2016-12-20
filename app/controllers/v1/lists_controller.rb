module V1
  class ListsController < ApplicationController
    def index
      @lists = paginate(List.all)
      render json: @lists, include: ['tasks'], status: 200
    end
  end
end
