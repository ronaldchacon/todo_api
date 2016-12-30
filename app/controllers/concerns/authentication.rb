module Authentication
  extend ActiveSupport::Concern
  include ActiveSupport::SecurityUtils

  private

  def authenticate_user
    unauthorized!("User Realm") unless access_token
  end

  def unauthorized!(realm)
    headers["WWW-Authenticate"] = %(Token realm="#{realm}")
    render(status: 401)
  end

  def authorization_request
    @authorization_request ||= request.authorization.to_s
  end

  def credentials
    @credentials ||= Hash[authorization_request.scan(/(\w+)[:=] ?"?([\w|:]+)"?/)]
  end

  def access_token
    @access_token ||= compute_access_token
  end

  def compute_access_token
    return nil if credentials["access_token"].blank?
    id, token = credentials["access_token"].split(":")
    user = id && token && User.find_by(id: id)
    access_token = user && AccessToken.find_by(user: user)
    return nil unless access_token
    if access_token.expired?
      access_token.destroy
      return nil
    end
    return access_token if access_token.authenticate(token)
  end

  def current_user
    @current_user ||= access_token.try(:user)
  end

  def secure_compare_with_hashing(a, b)
    secure_compare(Digest::SHA1.hexdigest(a), Digest::SHA1.hexdigest(b))
  end
end
