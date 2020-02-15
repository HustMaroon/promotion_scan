require_relative '../helpers/constants'
require 'json'
require 'byebug'
class CheckOut
  # items: {item_id => quantity}
  # rules: [Promotion]
  attr_accessor :rules, :items
  attr_reader :total

  def initialize(rules)
    @rules = rules
    @items = {}
    @total = 0
  end

  def scan(item)
    add_item(item)
    if @rules.empty?
      @total += item.price
      return
    end
    @total = before_promo_total
    # apply on_item promos
    discount = 0
    @rules.select{|r| r.type == Constants::PromotionType::ON_ITEM}.each do |promo|
      discount += item_discount_calculate(promo)
    end
    @total -= discount
    # apply on_total promos
    promo = @rules.select{|r| r.type == Constants::PromotionType::ON_TOTAL}.max_by(&:threshold)
    if promo && promo.threshold <= @total
      @total -= promo.percentage ? @total * promo.value/100 : promo.value
    end
  end

  private
  # adding item to checkout
  def add_item(item)
    if find_item(item.id).empty?
      @items[item.id] = 1
    else
      @items[item.id] += 1
    end
  end

  # find item in the list by id
  def find_item(id)
    @items.select{|item_id, quantity| item_id == id}
  end

  def item_discount_calculate(promo)
    applied_item = find_item(promo.item_id)
    quantity = applied_item&.values&.first
    return 0 if applied_item.nil? || quantity.nil? || quantity < promo.threshold # not satisfied
    # promo applied
    discount_on_each = promo.percentage ? item.price * promo.value/100 : promo.value
    quantity * discount_on_each
  end

  def before_promo_total
    total = 0
    @items.each do |id, quantity|
      price = get_price(id)
      total += price * quantity
    end
    total
  end

  private
  # mockup function to get item price
  def get_price(id)
    file = File.open('./spec/fixtures/items.json', 'r')
    content = file.read
    items = JSON.parse(content, object_class: OpenStruct)
    items.select{|item| item.id == id}.first&.price || 0
  end

end