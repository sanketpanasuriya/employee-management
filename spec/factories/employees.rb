FactoryBot.define do
  factory :employee do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    department { Faker::Job.field }
    salary { Faker::Number.number(digits: 6) }
  end
end
