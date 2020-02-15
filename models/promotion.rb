require './helpers/constants'
class Promotion
  # type: on_total, on_item
  # threshold: min_total or min_item
  # item_id: for on_item only
  # value: value to discount
  # percentage[bool]
  attr_accessor :type, :threshold, :item_id, :value, :percentage

  def initialize(type, threshold, value, percentage, item_id = nil)
    @type = type
    @threshold = threshold
    @item_id = item_id
    @value = value
    @percentage = percentage
    raise('item id required on on_item type') if @type == Constants::PromotionType::ON_ITEM && @item_id.nil?
  end
end