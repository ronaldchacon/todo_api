FactoryGirl.define do
  factory :list, aliases: [:personal] do
    title 'Personal List'
  end

  factory :work, class: List do
    title 'Work List'
  end

  factory :school, class: List do
    title 'School List'
  end
end
