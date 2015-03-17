class HomeController < ApplicationController
  def index
    @items = Item.all
    cookies["back_to"] = { :value => request.original_url, :path => '/' }
    @cart = Piggybak::Cart.new(cookies["cart"])
  end
end
