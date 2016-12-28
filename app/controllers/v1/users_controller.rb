module V1
  class UsersController < ApplicationController
    def show
      @user = User.find_by!(id: params[:id])
      render json: @user, status: 200
    end
  end
end
