FactoryGirl.define do
  factory :user do
    email "user@foobar.com"
    password "foobar"
    password_confirmation "foobar"
    confirmed_at { Time.current }
  end
end
