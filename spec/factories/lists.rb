FactoryGirl.define do
  factory :list, aliases: [:personal] do
    title 'Personal List'
    created_at "2016-12-18 09:06:14"
    user
  end

  factory :work, class: List do
    title 'Work List'
    created_at "2016-12-21 09:06:14"
    user
  end

  factory :school, class: List do
    title 'School List'
    created_at "2016-12-18 09:06:14"
    user
  end
end
