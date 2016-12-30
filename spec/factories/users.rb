FactoryGirl.define do
  factory :user do
    email "user@foobar.com"
    password "foobar"
    password_confirmation "foobar"

    trait :with_confirmation_token do
      confirmation_token "123"
    end

    trait :reset_password do
      reset_password_token "123"
      reset_password_redirect_url "http://example.com"
      reset_password_sent_at { Time.current }
    end
  end
end
