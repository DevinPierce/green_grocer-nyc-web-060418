require 'pry'

def consolidate_cart(cart)
  new_hash = {}
  cart.each do |item_hash|
    item_name = item_hash.keys[0]
    item_values = item_hash.values[0]
    new_hash[item_name] ||= item_values
    new_hash[item_name][:count] ||= 0
    new_hash[item_name][:count] += 1
  end
  new_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart.has_key?(coupon[:item]) && cart[coupon[:item]][:count] >= coupon[:num]
      cart[coupon[:item]][:count] -= coupon[:num]
      cart["#{coupon[:item]} W/COUPON"] ||=
        { price: coupon[:cost],
          clearance: cart[coupon[:item]][:clearance],
          count: 0
        }
      cart["#{coupon[:item]} W/COUPON"][:count] += 1
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, values|
    if values[:clearance] == true
      values[:price] = (values[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  total = 0
  cart.each do |item, values|
    total += (values[:price] * values[:count])
  end
  total > 100.00 ? total *= 0.9 : total
end
