class AddResetPasswordRedirectUrlToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :reset_password_redirect_url, :string
  end
end
