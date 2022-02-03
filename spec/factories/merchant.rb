FactoryBot.define do
  factory :merchant do
    sequence(:email) { |n| "email#{n}@domain.com" }
    password { '12345678' }
  end
end