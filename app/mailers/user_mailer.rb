class UserMailer < ApplicationMailer
  def reset_password(user)
    @user = user
    @user.update_column(:confirmation_sent_at, Time.current)
    mail to: @user.email, subject: "Reset your password"
  end
end
