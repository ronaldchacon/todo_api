FactoryGirl.define do
  factory :user do
    email "user@foobar.com"
    password "foobar"
    password_confirmation "foobar"

    trait :with_confirmation_token do
      confirmation_token "123"
    end
  end
end
