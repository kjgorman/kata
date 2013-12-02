class Item

  attr_accessor :sku, :price, :deals

  def initialize sku, price, deals
    @sku = sku
    @price = price
    @deals = deals
  end

  def to_s
    "ITEM: #{@sku} #{@price} #{@deals}"
  end

end

class Rule

  def apply list
    list
  end

  def applicable? list
    false
  end

  def saves list, original_price
    0
  end
end

class QuantityRule < Rule

  attr_accessor :sku, :quantity, :price

  def applicable? list
    applicable_skus = list.select { | sku | sku == @sku }
    applicable_skus.length >= @quantity
  end

  def saves list, original_price
    if self.applicable? list then
      (@quantity * original_price) - @price
    else
      0
    end
  end

  def apply list, prior_total
    if not self.applicable? list then
      return list, prior_total
    end
    prior_total = prior_total + @price
    @quantity.times do | _ |
      idx = list.index @sku
      list.delete_at idx
    end
    return list, prior_total
  end

  def initialize sku, quantity, price
    @sku = sku
    @quantity = quantity
    @price = price
  end

  def to_s
    "RULE: #{@sku} #{@quantity} #{@price}"
  end

end

RULES = Array.new

RULES << Item.new("A", 50, [] << QuantityRule.new("A", 3, 130))
RULES << Item.new("B", 30, [] << QuantityRule.new("B", 2, 45))
RULES << Item.new("C", 20, [])
RULES << Item.new("D", 15, [])
