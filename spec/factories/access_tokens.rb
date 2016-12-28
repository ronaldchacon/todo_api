FactoryGirl.define do
  factory :access_token do
    token_digest nil
    user
    accessed_at "2016-12-26 18:38:26"
  end
end
