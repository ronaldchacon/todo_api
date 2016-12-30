module V1
  module Users
    class PasswordResetsController < ApplicationController
      def create
        if reset.create
          UserMailer.reset_password(reset.user).deliver_now
          render status: :no_content, location: v1_user_url(reset.user)
        else
          respond_with_errors(reset)
        end
      end

      def show
        reset = PasswordReset.new(reset_token: params[:reset_token])
        redirect_to reset.redirect_url
      end

      def update
        reset.reset_token = params[:reset_token]
        if reset.update
          render status: :no_content
        else
          respond_with_errors(reset)
        end
      end

      private

      def reset
        @reset ||= PasswordReset.new(reset_params)
      end

      def reset_params
        params.require(:data).permit(:email, :reset_password_redirect_url,
                                     :password, :password_confirmation)
      end
    end
  end
end
