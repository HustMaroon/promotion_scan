require './models/item'
FactoryBot.define do
  factory :item do
    trait :item1 do
      id {1}
      code {'001'}
      name {'Lavender heart'}
      price {9.25}
    end
    trait :item2 do
      id {2}
      code {'002'}
      name {'Personalised cufflinks'}
      price {45}
    end
    trait :item3 do
      id {3}
      code {'003'}
      name {'Kids T-shirt'}
      price {19.95}
    end
  end
end