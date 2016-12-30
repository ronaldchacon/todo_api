module V1
  module Users
    class AccessTokensController < ApplicationController
      before_action :authenticate_user, only: :destroy

      def create
        user = User.find_by!(email: login_params[:email])
        if user.valid_password?(login_params[:password])
          AccessToken.find_by(user: user).try(:destroy)
          access_token = AccessToken.create(user: user)
          token = access_token.generate_token
          render json: access_token, meta: { token: token }, status: :created
        else
          render status: :unprocessable_entity,
                 json: { error: { message: "Invalid credentials." } }
        end
      end

      def destroy
        access_token.destroy
        render status: :no_content
      end

      private

      def login_params
        params.require(:data).permit(:email, :password)
      end
    end
  end
end
