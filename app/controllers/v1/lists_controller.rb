module V1
  class ListsController < ApplicationController
    def index
      @lists = filter(sort(paginate(List.all)))
      render json: @lists, include: ['tasks'], status: 200
    end
  end
end
