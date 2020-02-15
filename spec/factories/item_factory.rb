require './models/item'
require 'bigdecimal'
FactoryBot.define do
  file = File.open('./spec/fixtures/items.json', 'r')
  content = file.read
  items = JSON.parse(content, object_class: OpenStruct)
  factory :item do
    items.each_with_index do |item, index|
      trait "item#{index + 1}".to_sym do
        id {item.id}
        code {item.code}
        name {item.name}
        price {item.price}
      end
    end
  end
end