$: << File.dirname(__FILE__)
require "connect"

# START:define
require "rubygems"
require "active_record"

class Order < ActiveRecord::Base
end

#START:new1
an_order = Order.new
an_order.name     = "Dave Thomas"
an_order.email    = "dave@example.com"
an_order.address  = "123 Main St"
an_order.pay_type = "check"
an_order.save
#END:new1

#START:new2
Order.new do |o|
  o.name     = "Dave Thomas"
  # . . .
  o.save
end
#END:new2

#START:new3
an_order = Order.new(
  :name     => "Dave Thomas",
  :email    => "dave@example.com",
  :address  => "123 Main St",
  :pay_type => "check")
an_order.save
#END:new3

#START:new4
an_order = Order.new
an_order.name = "Dave Thomas"
# ...
an_order.save
puts "The ID of this order is #{an_order.id}"
#END:new4

#START:create1
an_order = Order.create(
  :name     => "Dave Thomas",
  :email    => "dave@example.com",
  :address  => "123 Main St",
  :pay_type => "check")
#END:create1

#START:create2
orders = Order.create(
  [ { :name     => "Dave Thomas",
      :email    => "dave@example.com",
      :address  => "123 Main St",
      :pay_type => "check"
    },
    { :name     => "Andy Hunt",
      :email    => "andy@example.com",
      :address  => "456 Gentle Drive",
      :pay_type => "po"
    } ] )
#END:create2
