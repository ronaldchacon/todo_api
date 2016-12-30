class User < ApplicationRecord
  has_many :access_tokens

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  def confirm
    update_columns(confirmation_token: nil, confirmed_at: Time.current)
  end

  def init_password_reset(redirect_url)
    assign_attributes(reset_password_token: SecureRandom.hex,
                      reset_password_sent_at: Time.current,
                      reset_password_redirect_url: redirect_url)
    save
  end

  def complete_password_reset(password, password_confirmation)
    assign_attributes(password: password,
                      password_confirmation: password_confirmation,
                      reset_password_token: nil,
                      reset_password_sent_at: nil,
                      reset_password_redirect_url: nil)
    save
  end
end
