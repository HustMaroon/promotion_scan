require_relative '../../models/promotion'
require_relative '../../helpers/constants'
require_relative '../../spec/spec_helper'
require 'bigdecimal'
FactoryBot.define do
  factory :promotion do
    trait :promo1 do
      type {Constants::PromotionType::ON_ITEM}
      threshold {2}
      item_id {build(:item, :item1).id}
      value {BigDecimal('0.75')}
      percentage {false}
      initialize_with{Promotion.new(type, threshold, value, percentage, item_id)}
    end
    trait :promo2 do
      type {Constants::PromotionType::ON_TOTAL}
      threshold {60}
      value {10}
      percentage {true}
      initialize_with{Promotion.new(type, threshold, value, percentage)}
    end

    trait :promo3 do
      type {Constants::PromotionType::ON_TOTAL}
      threshold {80}
      value {40}
      percentage {false}
      initialize_with{Promotion.new(type, threshold, value, percentage)}
    end
  end
end