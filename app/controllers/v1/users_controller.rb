module V1
  class UsersController < ApplicationController
    def show
      @user = User.find_by!(id: params[:id])
      render json: @user, status: 200
    end

    def create
      @user = User.new(user_attributes)
      if @user.save
        render json: @user, status: :created, location: v1_user_url(@user)
      else
        respond_with_errors(@user)
      end
    end

    def update
      @user = User.find_by!(id: params[:id])
      if @user.update(user_attributes)
        render json: @user, status: :ok, location: v1_user_url(@user)
      else
        respond_with_errors(@user)
      end
    end

    def destroy
      User.find_by!(id: params[:id]).destroy
      render status: :no_content
    end

    private

    def user_params
      params.require(:data).permit(:type, attributes: [:email, :password,
                                                       :password_confirmation])
    end

    def user_attributes
      user_params[:attributes] || {}
    end
  end
end
