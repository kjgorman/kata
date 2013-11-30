require "./PriceRules"

class CheckOut

  def initialize rules
    @rules = rules
    @current_best = 0
    @items = Array.new
  end

  def total
    @current_best
  end

  def scan item
    @items << item
    rules = find_applicable_rules
    rules = rules.sort do | x, y |
      x.saves(@items, price_of(item)) - y.saves(@items, price_of(item))
    end

    total = 0
    list = @items.clone
    while rules.length > 0
      current_rule = rules[0]
      if current_rule.applicable? list then
        list, total = current_rule.apply list, total
      else
        rules.shift
      end
    end

    list.each do | item |
      total = total + price_of(item)
    end

    @current_best = total
  end

  def price_of item
    match = RULES.find { | r | r.sku == item }
    if match != nil then
      match.price
    else
      0
    end
  end

  def find_applicable_rules
    RULES.flat_map { | r | r.deals }
         .select { | r | r.applicable? @items }
  end
end
