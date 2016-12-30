module V1
  module Users
    class ConfirmationsController < ApplicationController
      before_action :confirmation_token_not_found

      def show
        user.confirm
        render plain: "You are now confirmed!"
      end

      private

      def confirmation_token_not_found
        render(status: 404, plain: "Token not found") unless user
      end

      def confirmation_token
        @confirmation_token ||= params[:confirmation_token]
      end

      def user
        @user ||= User.where(confirmation_token: confirmation_token).first
      end
    end
  end
end
