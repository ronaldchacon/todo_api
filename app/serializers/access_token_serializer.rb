class AccessTokenSerializer < ActiveModel::Serializer
  attributes :id, :token, :user_id

  def token
    :token
  end
end
